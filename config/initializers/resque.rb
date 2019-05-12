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

  Resque.redis = "redis://%s%s:%s%s" % [
      password,
      resque_config['host'],
      resque_config['port'],
      channel
  ]
end