module Users::SettingsDecorator
  extend ActiveSupport::Concern

  SETTINGS_KEYS = [:view, :notifications, :email]

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

  def get_settings
    obj = self.to_settings_hash.deep_symbolize_keys
    # TODO Remove this once the UI is patched to use the View key.
    obj.merge(obj[:view])
  end

  def set_settings(settings)
    not_implemented
  end
end
