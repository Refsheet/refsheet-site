HttpLog&.configure do |config|

  # Enable or disable all logging
  config.enabled = !Rails.env.production?
  # config.logger = Rails.logger

  # I really wouldn't change this...
  config.severity = Logger::Severity::DEBUG

  # Tweak which parts of the HTTP cycle to log...
  config.log_connect   = true
  config.log_request   = true
  config.log_headers   = true
  config.log_data      = true
  config.log_status    = true
  config.log_response  = true
  config.log_benchmark = true

  # ...or log all request as a single line by setting this to `true`
  config.compact_log = true

  # Prettify the output - see below
  config.color = :blue

  # Limit logging based on URL patterns
  config.url_whitelist_pattern = /.*/
  # Ignore Capybara Spam
  config.url_blacklist_pattern = /95\d\d\/session/
end
puts 'Initializing config/initializers/http_log.rb'
