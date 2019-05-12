Rails.application.configure do
  if Rails.env.development?
    Resque.logger = ActiveSupport::Logger.new(STDOUT)
    Resque.logger.formatter = Resque::VerboseFormatter.new
    Resque.logger.level = Logger::DEBUG
  end

  resque_config = config_for(:resque)
  password = ""
  channel = ""

  if resque_config['password'].present?
    password = ":%s@" % resque_config['password']
  end

  redis_path = "redis://%s%s:%s%s" % [
      password,
      resque_config['host'],
      resque_config['port'],
      channel
  ]

  Rails.logger.info "Connecting to Redis on: #{redis_path}"

  Resque.redis = redis_path
end