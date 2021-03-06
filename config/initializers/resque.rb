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
    password = ":%s@" % URI.encode(resque_config['password'])
  end

  redis_path = "redis://%s%s:%s%s" % [
      password,
      resque_config['host'],
      resque_config['port'],
      channel
  ]

  if password.present?
    Rails.logger.info("Connecting to Redis with password: " + redis_path.gsub(password, ":********@"))
  else
    Rails.logger.info("Connecting to Redis: " + redis_path)
  end

  Resque.redis = redis_path

  ActiveJob::Uniqueness.configure do |config|
    config.on_conflict = :log
    config.redlock_servers = [
        ENV.fetch('REDIS_URL', redis_path)
    ]
  end
end
