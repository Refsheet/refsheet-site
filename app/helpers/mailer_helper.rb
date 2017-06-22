module MailerHelper
  def button(text, path, options={})
    primary = options.delete(:primary) || false
    last = options.delete(:last) || true

    button_classes = %w(btn)
    button_classes.push 'btn-primary' if primary

    button_td_classes = []
    button_td_classes.push 'last' if last

    content_tag :table, border: 0, cellpadding: 0, cellspacing: 0, class: button_classes.join(' ') do
      content_tag :tbody do
        content_tag :tr do
          content_tag :td, align: 'left', class: button_td_classes.join(' ') do
            content_tag :table, border: 0, cellpadding: 0, cellspacing: 0 do
              content_tag :tbody do
                content_tag :tr do
                  content_tag :td, link_to(text, path, { target: '_blank' }.merge(options))
                end
              end
            end
          end
        end
      end
    end
  end
end
