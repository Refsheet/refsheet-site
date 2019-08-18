Rails.application.configure do
  if ENV['DEFAULT_URL_HOST'].present?
    Rails.application.routes.default_url_options[:host] = ENV['DEFAULT_URL_HOST']
  elsif Rails.env.production?
    Rails.application.routes.default_url_options[:host] = 'refsheet.net'
    Rails.application.routes.default_url_options[:protocol] = :https
  else
    Rails.application.routes.default_url_options[:host] = "dev1.refsheet.net:5000"
  end
end
