Rails.application.configure do
  # Test gcloud logging
  # config.google_cloud.project_id = "refsheet-239409"
  # config.google_cloud.keyfile = "refsheet-prod.json"
  # config.google_cloud.use_logging = false
  # config.google_cloud.logging.log_name = "refsheet-prod"
  # config.google_cloud.logging.resource = "global"
  #
  # # Gcloud Trace
  # config.google_cloud.use_trace = true

  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = false

  # Settings specified here will take precedence over those in config/application.rb.
  config.colorize_logging = false

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier_with_source_maps
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true
  # TODO: THIS IS REALLY BAD, but required for react-router-rails to do the correct thing.

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.

  if ENV['ASSET_DOMAIN']
    config.action_controller.asset_host = "https://#{ENV['ASSET_DOMAIN']}"
  end

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :google

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  config.action_cable.allowed_request_origins = %w(
    https://prod.refsheet.net
    https://staging.refsheet.net
    https://green.refsheet.net
    https://blue.refsheet.net
    https://kube.refsheet.net
    https://refsheet.net
    https://websocket.org
  )

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  config.active_job.queue_adapter = :resque

  if ENV['SENDGRID_API_KEY']
    config.action_mailer.delivery_method = :sendgrid_actionmailer
    config.action_mailer.sendgrid_actionmailer_settings = {
        api_key: ENV['SENDGRID_API_KEY'],
        raise_delivery_errors: true
    }
  elsif !ENV['GOOGLE_CLOUD']
    config.action_mailer.delivery_method = :ses
  else
    config.action_mailer.delivery_method = :smtp
  end

  # config.active_job.queue_name_prefix = "refsheet-site_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  # config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  # if ENV["RAILS_LOG_TO_STDOUT"].present?
  STDOUT.sync = true

  config.rails_semantic_logger.add_file_appender = false
  config.rails_semantic_logger.format = Refsheet::LogFormatter.new

  config.log_tags = {
      request_id: :request_id,
      ip: :remote_ip,
      username: -> request { SessionHelper.user_jar(request) }
  }

  config.semantic_logger.add_appender(io: STDOUT, level: config.log_level, formatter: config.rails_semantic_logger.format)
  # end

  # config.logger = Refsheet::Logger.new(STDOUT)

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
