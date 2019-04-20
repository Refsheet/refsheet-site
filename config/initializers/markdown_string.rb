require 'redcarpet/render_strip'

class MarkdownString < String
  USER_TAG_REGEX = /(?:^|\s|>)@(@?)([a-z0-9_\/+-]+)/i

  EXTENSIONS = {
      autolink: true,
      hard_wrap: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      underline: true,
      lax_spacing: true,
      highlight: true
  }

  HTML_OPTIONS = {
      filter_html: false,
      with_toc_data: true,
      hard_wrap: true,
      prettify: true,
      link_attributes: {
          target: "_blank",
          rel: "external nofollow"
      }
  }

  def self.html_renderer
    renderer = MarkdownString::Render.new(HTML_OPTIONS)
    @@html_renderer ||= Redcarpet::Markdown.new(renderer, EXTENSIONS)
  end

  def self.text_renderer
    renderer = Redcarpet::Render::StripDown
    @@text_renderer ||= Redcarpet::Markdown.new(renderer, EXTENSIONS)
  end

  def to_html
    self.class.html_renderer.render(self).html_safe
  end

  def to_text
    self.class.text_renderer.render self
  end

  def extract_tags(options = {})
    tags = _find_tags to_text

    if options[:only_users] or options[:only_mentions] or options[:only_characters]
      tags.reject! { |t| t[:textless] }
    end

    if options[:only_characters]
      tags.select! { |t| t[:character].present? }
    end

    if options[:only_users]
      tags.reject! { |t| t[:character].present? }
    end

    tags
  end

  class Render < Redcarpet::Render::HTML
    class Helper
      include RichTextHelper
      def process(text)
        # Add mention tokens
        text = linkify(text, no_markdown: true)

        # correct numbered list format
        text = text.gsub(/^(\s*)(\d+)\)(\s+)/, '\1\2.\3')

        text
      end
    end

    def preprocess(text)
      Helper.new.process(text)
    end

    def image(link, title, alt_text)
      url = ImageProxyController.generate(link)

      %Q[<img src="#{url}" alt="#{alt_text}" title="#{title}" data-canonical-url="#{link}" />]
    end
  end

  class ::String
    def to_md
      MarkdownString.new self
    end

    def to_markdown
      to_md
    end
  end

  class ::NilClass
    def to_md
      nil
    end

    def to_markdown
      nil
    end
  end

  class ::ActiveRecord::Base
    class << self
      def has_markdown_field(name, options={})
        cache_column = options.fetch(:cache_column) { name.to_s + '_html' }
        cache_present = column_names.include? cache_column

        define_method(name) do
          super().to_md
        end

        if cache_present
          define_method(cache_column) do
            super()&.html_safe
          end

          before_save do
            assign_attributes cache_column => send(name)&.to_html
          end
        else
          define_method(cache_column) do
            send(name)&.to_html
          end
        end
      end
    end
  end

  private

  def _find_tags(text)
    tags = []

    text.gsub USER_TAG_REGEX do |_|
      $2.split('+').collect do |chip|
        username, character = chip.split '/'
        textless = $1 == '@'

        tags.push({
            username: username,
            character: character,
            textless: textless
        })
      end
    end

    tags
  end
end
