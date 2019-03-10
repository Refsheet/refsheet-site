if Rails.env.development?
  Resque.logger = ActiveSupport::Logger.new(STDOUT)
  Resque.logger.formatter = Resque::VerboseFormatter.new
  Resque.logger.level = Logger::DEBUG
  puts Resque.logger.inspect
  puts Rails.logger.inspect
  Rails.logger.info("Resque initialized.")
end