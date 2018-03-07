class Account::NotificationsController < AccountController
  in_beta!

  def index
    @notifications = filter_scope current_user.notifications.eager_loaded

    filters = {
        reply: 'ForumReply',
        comment: 'ImageComment',
        favorite: 'ImageFavorite',
        tag: 'ForumTag'
    }

    if params[:filter] and (filter = filters[params[:filter].downcase.to_sym])
      @notifications = @notifications.where('notifications.type' => 'Notifications::' + filter)
    end

    respond_to do |format|
      format.html do
        render 'application/show'
      end

      format.json do
        render api_collection_response @notifications, each_serializer: NotificationSerializer, root: 'notifications'
      end
    end
  end

  def show

  end

  def update
    if params[:id]
      notification = current_user.notifications.find_by! guid: params[:id]

      Rails.logger.info "READ: " + notification.read_at.inspect
      if params.include? :read
        read = params[:read] == 'true' ? Time.zone.now : nil
        notification.update_attributes read_at: read
      end
      Rails.logger.info "POST: " + notification.read_at.inspect

      render json: notification, serializer: NotificationSerializer
    end
  end

  def bulk_update
    read = params[:read] == 'true' ? Time.zone.now : nil
    notifications = current_user.notifications.where guid: params[:ids]
    notifications.update_all read_at: read
    render json: { ids: notifications.pluck(:id), read: !read.nil? }
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
