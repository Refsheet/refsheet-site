class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = true

# better user agent parsing
Ahoy.user_agent_parser = :device_detector

Ahoy.job_queue = :refsheet_application_queue
