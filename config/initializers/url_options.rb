Rails.application.configure do
  if ENV['DEFAULT_URL_HOST'].present?
    Rails.application.routes.default_url_options[:host] = ENV['DEFAULT_URL_HOST']
  elsif Rails.env.production?
    Rails.application.routes.default_url_options[:host] = 'refsheet.net'
    Rails.application.routes.default_url_options[:protocol] = :https
  else
    Rails.application.routes.default_url_options[:host] = "#{ENV.fetch("URL_HOSTNAME", 'localhost')}:#{ENV.fetch('PORT', 5000)}"
  end

  if ENV['ACTIVE_STORAGE_HOST'].present?
    ActiveStorage::Current.host = ENV['ACTIVE_STORAGE_HOST']
  else
    ActiveStorage::Current.host = "%s://%s" % [
        Rails.application.routes.default_url_options[:protocol] || 'http',
        Rails.application.routes.default_url_options[:host],
    ]
  end
end
