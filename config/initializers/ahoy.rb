class Ahoy::Store < Ahoy::DatabaseStore
end

Ahoy.api = true
Ahoy.user_agent_parser = :device_detector
Ahoy.job_queue = :refsheet_application_queue
Ahoy.geocode = false