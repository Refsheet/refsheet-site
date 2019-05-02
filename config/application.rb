require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require 'trello'
require 'google/cloud/logging/rails'
require 'google/cloud/trace/rails'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Refsheet

  #== Marketplace Constants

  MARKETPLACE_FEE_PERCENT = 0.045
  MARKETPLACE_FEE_AMOUNT  = 0

  VERSION = File.read 'VERSION'

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('lib')

    config.time_zone = 'Central Time (US & Canada)'
    config.active_record.default_timezone = :utc
  end
end
