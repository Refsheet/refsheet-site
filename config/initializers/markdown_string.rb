require 'redcarpet/render_strip'

class MarkdownString < String
  EXTENSIONS = {
      autolink: true
  }

  def self.html_renderer
    renderer = Redcarpet::Render::HTML
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
end
