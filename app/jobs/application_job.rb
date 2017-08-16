class ApplicationJob < ActiveJob::Base
  queue_as :refsheet_application_queue
end
