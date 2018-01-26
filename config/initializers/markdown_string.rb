require 'redcarpet/render_strip'

class MarkdownString < String
  include RichTextHelper

  EXTENSIONS = {
      autolink: true
  }

  HTML_OPTIONS = {
      escape_html: true,
      hard_wrap: true,
      prettify: true
  }

  def self.html_renderer
    renderer = Redcarpet::Render::HTML.new(HTML_OPTIONS)
    @@html_renderer ||= Redcarpet::Markdown.new(renderer, EXTENSIONS)
  end

  def self.text_renderer
    renderer = Redcarpet::Render::StripDown
    @@text_renderer ||= Redcarpet::Markdown.new(renderer, EXTENSIONS)
  end

  def to_html
    linkify self.class.html_renderer.render(self).html_safe
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

  private

  def _find_tags(text)
    tags = []

    text.gsub /(?<!\\)@(@?)([a-z0-9_\/+-]+)/i do |_|
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
