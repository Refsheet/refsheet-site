Rails.application.configure do
  # Test gcloud logging
  # config.google_cloud.project_id = "refsheet-239409"
  # config.google_cloud.keyfile = "refsheet-prod.json"
  # config.google_cloud.use_logging = false
  # config.google_cloud.logging.log_name = "refsheet-dev"
  # config.google_cloud.logging.resource = "global"
  #
  # Gcloud Trace
  config.google_cloud.use_logging = false
  config.google_cloud.use_trace = false
  config.google_cloud.use_error_reporting = false
  config.google_cloud.use_debugger = false
  # config.google_cloud.trace.capture_stack = true
  # config.google_cloud.trace.sampler = -> (_x) { true }

  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = false

  # Settings specified here will take precedence over those in config/application.rb.
  # config.logger = Refsheet::Logger.new(STDOUT)
  STDOUT.sync = true

  config.log_tags = {
      request_id: :request_id,
      ip: :remote_ip,
      username: -> request { SessionHelper.user_jar(request) }
  }

  config.rails_semantic_logger.add_file_appender = false
  # config.rails_semantic_logger.format = Refsheet::LogFormatter.new
  # config.semantic_logger.add_appender(io: STDOUT, level: config.log_level, formatter: config.rails_semantic_logger.format)

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.delivery_method = :letter_opener_web
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  if ENV['DEFAULT_URL_HOST']
    config.action_controller.asset_host = "http://#{ENV['DEFAULT_URL_HOST']}"
  end

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.file_watcher = ActiveSupport::FileUpdateChecker

  config.active_job.queue_adapter = :resque

  config.after_initialize do
    Bullet.enable = true
    Bullet.rails_logger = true
  end

  config.action_cable.allowed_request_origins = %w(
    http://localhost
    http://localhost:5000
    http://dev.refsheet.net:5000
    http://dev1.refsheet.net:5000
    http://dev.refsheet.net:3200
    http://dev1.refsheet.net:3200
    https://websocket.org
  )

  config.hosts << 'dev.refsheet.net'
  config.hosts << 'dev1.refsheet.net'

  config.web_console.permissions = '192.168.0.0/16'
  config.web_console.whiny_requests = false
end
