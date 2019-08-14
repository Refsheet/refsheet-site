require 'freshdesk'

Freshdesk.configure do |config|
  config.domain = "refsheet"
  config.api_key = ENV['FRESHDESK_API_KEY'] || "x"
end
puts 'Initializing config/initializers/freshdesk.rb'
