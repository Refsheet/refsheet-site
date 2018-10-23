module Users::SettingsDecorator
  extend ActiveSupport::Concern

  included do
    has_settings do |s|
      s.key :view, defaults: {
          nsfw_ok: false,
          locale: nil,
          time_zone: nil
      }

      s.key :notifications, defaults: {
          vapid_registrations: [],
          browser_push: {},
          email: {}
      }

      s.key :email, defaults: {
          mailing_list: nil,
          internal_blacklist: [],
          opt_out_all: false
      }
    end
  end
end
