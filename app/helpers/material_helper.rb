module MaterialHelper
  def material_icon(icon, text=nil, options={})
    text, options = nil, text if text.is_a? Hash

    capture do
      concat content_tag :i, icon, class: ['material-icons', options[:class]].flatten.join(' ')
      concat text
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
end