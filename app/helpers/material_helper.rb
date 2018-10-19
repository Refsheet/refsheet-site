module MaterialHelper
  def toast(level_or_hash=:notice, message='', options={})
    if level_or_hash.is_a? Hash
      message = level_or_hash.values.first
      level_or_hash = level_or_hash.keys.first
    end

    flash_map = {
        notice: 'green',
        info:   'blue',
        warn:   'yellow',
        error:  'red'
    }

    klass = flash_map[level_or_hash.to_sym] || level_or_hash.to_s

    message = "<span aria-live=\"polite\">#{ message }</span>"

    if options[:no_wrapper]
      <<-JAVASCRIPT.html_safe
        Materialize.toast("#{escape_javascript message}", 5000, "#{klass}")
      JAVASCRIPT
    else
      <<-HTML.html_safe
        <script type="text/javascript">
            Materialize.toast("#{escape_javascript message}", 5000, "#{klass}")
        </script>
      HTML
    end
  end

  def material_icon(icon, text=nil, options={})
    text, options = nil, text if text.is_a? Hash

    class_names = ['material-icons']
    class_names.push options[:class] if options[:class]

    capture do
      concat content_tag :i, icon, options.merge(class: class_names.flatten.join(' '))
      concat text if text.present?
    end
  end

  def action_button(icon, href, options={})
    klass = options.delete :class
    tooltip = options.delete :tooltip

    capture do
      content_tag :div, class: 'fixed-action-btn' do
        concat link_to material_icon(icon), href, {
            class: "btn-floating btn-large waves-effect waves-light tooltipped #{klass || 'red'}",
            data: {
                tooltip: tooltip,
                position: :left,
                delay: 0
            }
        }.merge(options)

        if block_given?
          concat content_tag(:ul) { capture { yield } }
        end
      end
    end
  end

  def action_button_child(icon, href, options={})
    klass = options.delete :class
    tooltip = options.delete :tooltip

    capture do
      content_tag :li do
        concat link_to material_icon(icon), href, {
            class: "btn-floating waves-effect waves-light tooltipped #{klass || 'black'}",
            data: {
                tooltip: tooltip,
                position: 'left',
                delay: 0
            }
        }.merge(options)
      end
    end
  end

  def progress_bar(count, total=nil, display_text=nil)
    if total.nil? or total.kind_of? String
      display_text = total
      percent = count
      count = nil
      total = nil
    else
      percent = (count.to_f / total) * 100
    end

    content_tag :div, class: 'progress-bar' do
      concat content_tag(:div, class: 'progress grey lighten-1') {
        content_tag :div, '', class: 'determinate', style: "width: #{percent}%;"
      }

      if display_text.present?
        formatted_text = display_text % {
            percent: percent,
            count: count,
            total: total
        }

        concat content_tag :div, formatted_text, class: 'progress-message muted'
      end
    end
  end
end
