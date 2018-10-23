module Users::NotificationsDecorator
  def register_vapid!(endpoint:, p256dh:, auth:, nickname: nil)
    vapid = settings(:notifications).vapid.dup

    auth = {
        endpoint: endpoint,
        p256dh: p256dh,
        auth: auth,
        nickname: nickname
    }

    vapid.reject! { |v| v[:endpoint] == auth[:endpoint] }
    vapid.push auth

    settings(:notifications).update_attributes vapid: vapid
  end

  def notify!(title, body=nil, options={})
    vapid = settings(:notifications).vapid
    return unless vapid

    m = {
        title: title,
        body: body
    }.merge options

    message = {
        message: m.to_json,
        vapid: Rails.configuration.x.vapid.merge(expiration: 12.hours)
    }

    vapid.each do |browser|
      payload = browser.without(:nickname).merge(message)
      Webpush.payload_send payload
    end
  rescue => e
    Rails.logger.warn e
    false
  end
end
