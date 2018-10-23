module Users::SettingsDecorator
  extend ActiveSupport::Concern

  included do
    has_settings do |s|
      s.key :view, defaults: {
          nsfw_ok: false,
          locale: nil,
          time_zone: nil
      }
    end
  end
end
