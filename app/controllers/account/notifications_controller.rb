class Account::NotificationsController < AccountController
  in_beta!

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
                         href: account_notifications_url

    render json: current_user, serializer: PrivateUserSerializer
  end
end
