class BackfillUserSettings < ActiveRecord::Migration[5.0]
  def up
    User.where.not(settings: nil).find_each do |user|
      settings_data = user.attributes['settings']
      settings = JSON.parse(settings_data) rescue nil
      next unless settings

      view = {
          nsfw_ok: settings['nsfw_ok'],
          time_zone: settings['time_zone'],
          locale: settings['locale']
      }

      notifications = {
          vapid: [settings['vapid']]
      }

      user.settings(:view).update_attributes view
      user.settings(:notifications).update_attributes notifications
    end
  end
end
