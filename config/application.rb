require_relative 'boot'

require "rails"

# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_cable/engine"
require "active_storage/engine"
require "action_text/engine"
# require "action_view/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Refsheet

  #== Marketplace Constants

  MARKETPLACE_FEE_PERCENT = 0.045
  MARKETPLACE_FEE_AMOUNT  = 0

  VERSION = File.read 'VERSION'

  class Application < Rails::Application
    # Set API Only mode for the new split frontend/backend, but we need our middleware for cookies.
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    config.railties_order = [:all, :main_app]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('lib')

    config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :utc

    # ActiveStorage
    config.active_storage.variant_processor = :vips
  end
end

if defined? RSpec
  RSpec.configure do |config|
    config.swagger_dry_run = false
  end
end
