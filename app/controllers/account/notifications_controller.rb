class Account::NotificationsController < AccountController
  def show

  end

  def update

  end

  def browser_push
    Rails.logger.info current_user.settings.inspect

    current_user.settings = current_user.settings.merge( vapid: {
        endpoint: params[:subscription][:endpoint],
        p256dh: params[:subscription][:keys][:p256dh],
        auth: params[:subscription][:keys][:auth],
    })

    current_user.save!
    current_user.notify! 'Notifications Enabled!',
                         'Notifications have been enabled for Refsheet.net!',
                         account_notifications_url

    head :no_content
  end
end
