Rails.application.configure do
  if Rails.env.production?
    Rails.application.routes.default_url_options[:host] = 'refsheet.net'
    Rails.application.routes.default_url_options[:protocol] = :https
  else
    Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  end
end

puts 'Initializing config/initializers/url_options.rb'
