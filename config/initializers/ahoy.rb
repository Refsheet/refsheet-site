class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.api = true
Ahoy.user_agent_parser = :device_detector
Ahoy.job_queue = :refsheet_application_queue
puts 'Initializing config/initializers/ahoy.rb'
