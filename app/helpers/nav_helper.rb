module NavHelper
  def nav_link_to(icon, text, path, options = {}, &block)
    notify = options.delete(:count)
    notify_new = options.delete(:new)
    current = options.delete(:current)
    match_action = options.delete(:match_action)
    active_controllers = options.delete(:active_controllers)
    tab = !!options.delete(:tab)
    li_classes = [options.delete(:class)]
    li_classes.push 'tab' if tab

    #== Current

    if (active_if = options.delete :active_if)
      current = active_if.call
    else
      begin
        root_path = @breadcrumbs.try(:first).try(:compute_path, self)

        if root_path
          current = path == root_path
        elsif path[0] == '#'
          current = false
        else
          route = Rails.application.routes.recognize_path(request.base_url + path)

          current = (active_controllers || [route[:controller]]).include?(params[:controller]) &&
              (!match_action or route[:action] == params[:action])

          if (cwp = options.delete(:watch_params))
            q = path&.split('?', 2)
            route_params = q.nil? || q[1].nil? ? {} : CGI::parse(q[1])
            cwp.each { |p| current = false unless route_params[p.to_s]&.include?(params[p]) or (route_params[p.to_s].nil? and params[p].nil?) }
          end
        end
      rescue ActionController::RoutingError => e
        current = false
        Rails.logger.info "#{e.class.name} => #{e.message}"
      end
    end

    li_classes.push 'active current' if current

    #== Delete Links

    if options[:method] == :delete and (!options[:data] or !options[:data][:confirm])
      options[:data] = {} unless options[:data]
      options[:data][:confirm] = 'Are you sure you want to delete this?'
    end

    #== Notify

    notify = nil if notify == 0
    notify_count = !!notify == notify ? nil : notify
    notify_class = notify_new ? 'badge new' : 'badge'

    #== Render

    content_tag :li, {class: li_classes.join(' ')}.merge(options) do
      notify_classes = %w(notify)
      notify_classes.push notify_class if notify

      capture do
        concat link_to(path, class: current ? 'current active' : '', target: tab ? '_self' : '') {
          capture do
            concat material_icon(icon, class: 'left') if icon.present?
            concat content_tag(:span, text, class: 'link-text')
            concat content_tag(:span, notify_count, class: notify_classes.join(' ')) if notify
          end
        }

        if current and block
          concat content_tag :ul, capture { block.call }, class: 'submenu'
        end
      end
    end
  end

  def nav_divider(title)
    capture do
      concat content_tag :li, content_tag(:div, nil, class: 'divider')
      concat content_tag :li, content_tag(:a, title, class: 'subheader') if title.present?
    end
  end
end
