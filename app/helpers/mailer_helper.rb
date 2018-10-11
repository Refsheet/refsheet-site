module MailerHelper
  def button(text, path, options={})
    primary = options.delete(:primary) || false
    last = options.delete(:last) || true
    type = options.delete(:type)

    button_classes = %w(btn)
    button_classes.push 'btn-primary' if primary

    button_td_classes = []
    button_td_classes.push 'last' if last

    if primary
      potential_action = case type.to_s
        when "confirm"
          <<-JSON
              {
                "@type": "ConfirmAction",
                "name": "#{escape_javascript text}",
                "handler": {
                  "@type": "HttpActionHandler",
                  "url": "#{path}"
                }
              }
          JSON
        else
          <<-JSON
              {
                "@type": "ViewAction",
                "target": {
                  "url": "#{path}",
                }
                "url": "#{path}",
                "name": "#{escape_javascript text}"
              }
          JSON
      end

      content_for(:head_script) do
        content_tag :script, <<-JSON.squish, type: 'application/ld+json'
            {
              "@context": "http://schema.org",
              "@type": "EmailMessage",
              "description": "#{escape_javascript(options[:title] || text)}",
              "potentialAction": #{potential_action},
              "publisher": {
                "@type": "Organization",
                "name": "Refsheet.net",
                "url": "https://refsheet.net"            
              }
            }
        JSON
      end
    end

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
