Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.release = Refsheet::VERSION
end

RestClient.add_before_execution_proc do |_req, params|
  Raven.breadcrumbs.record do |crumb|
    crumb.data = params
    crumb.category = 'rest-client'
    crumb.timestamp = Time.now.to_i
    crumb.message = "#{params[:method].upcase} #{params[:url]}"
  end
end
