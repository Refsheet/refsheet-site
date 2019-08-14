$markdown = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML,
    autolink: true,
    tables: true,
    fenced_code_blocks: true,
    strikethrough: true,
    disable_indented_code_blocks: true,
    underline: true,
    hard_wrap: true
)
puts 'Initializing config/initializers/markdown.rb'
