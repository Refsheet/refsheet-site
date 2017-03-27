module NavHelper
  def nav_link_to(icon, text, path, options = {})
    notify = options.delete(:notify)
    notify = nil if notify == 0
    notify_count = !!notify == notify ? nil : notify

    begin
      root_path = @breadcrumbs.try(:first).try(:compute_path, self)

      if root_path
        current = path == root_path
      else
        current = Rails.application.routes.recognize_path(request.base_url + path)[:controller] == params[:controller]
      end
    rescue ActionController::RoutingError => e
      current = false
      Rails.logger.info "#{e.class.name} => #{e.message}"
    end

    if options[:method] == :delete and (!options[:data] or !options[:data][:confirm])
      options[:data] = {} unless options[:data]
      options[:data][:confirm] = 'Are you sure you want to delete this?'
    end

    content_tag :li, {class: current ? 'current active' : ''}.merge(options) do
      link_to path do
        material_icon(icon, class: 'left') +
            content_tag(:span, notify_count, class: notify ? 'badge' : '') +
            content_tag(:span, text, class: :link_text)
      end
    end
  end
end
