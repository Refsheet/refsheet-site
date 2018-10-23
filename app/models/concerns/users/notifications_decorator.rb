module Users::NotificationsDecorator
  def register_vapid!(endpoint:, p256dh:, auth:)
    vapid = current_user.settings(:notifications).vapid_registrations.dup

    auth = {
        endpoint: endpoint,
        p256dh: p256dh,
        auth: auth
    }

    vapid.reject! { |v| v[:endpoint] == auth[:endpoint] }
    vapid.push auth

    current_user.settings(:notifications).update_attributes vapid_registrations: vapid
  end

  def notify!(title, body=nil, options={})
    vapid = settings(:notifications).vapid_registrations
    return unless vapid

    m = {
        title: title,
        body: body
    }.merge options

    vapid.each do |browser|
      Webpush.payload_send browser.merge(
          message: m.to_json,
          vapid: Rails.configuration.x.vapid.merge(expiration: 12.hours)
      )
    end
  rescue => e
    Rails.logger.warn e
    false
  end
end
