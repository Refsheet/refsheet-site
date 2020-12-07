module Users::NotificationsDecorator
  def register_vapid!(endpoint:, p256dh:, auth:, nickname: nil)
    vapid = settings(:notifications).vapid.dup

    new_registration = {
        endpoint: endpoint,
        p256dh: p256dh,
        auth: auth,
        nickname: nickname
    }

    vapid.reject! { |v| v[:auth] == new_registration[:auth] }
    vapid.push new_registration

    settings(:notifications).update vapid: vapid
  end

  def remove_vapid_auth!(auth)
    vapid = settings(:notifications).vapid.dup
    vapid.reject! { |v| v[:auth] == auth }
    settings(:notifications).update vapid: vapid
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
      browser.deep_symbolize_keys!
      Rails.logger.info browser.inspect

      begin
        Webpush.payload_send endpoint: browser[:endpoint],
                             p256dh: browser[:p256dh],
                             auth: browser[:auth],
                             message: message[:message],
                             vapid: message[:vapid]
      rescue Webpush::InvalidSubscription => e
        remove_vapid_auth! browser[:auth]
        Rails.logger.warn e
        Rails.logger.warn "Vapid auth invalid, removing from user #{self.id}"
      end
    end
  rescue => e
    Rails.logger.warn e
    Rails.logger.warn e.backtrace.first(10).join("\n")
    false
  end
end
