Rails.application.configure do
  if Rails.env.production?
    Rails.application.routes.default_url_options[:host] = 'refsheet.net'
    Rails.application.routes.default_url_options[:protocol] = :https
  else
    Rails.application.routes.default_url_options[:host] = "#{ENV.fetch("URL_HOSTNAME", 'dev1.refsheet.net')}:#{ENV.fetch('PORT', 5000)}"
  end
end

