class Mutations::NotificationMutations < Mutations::ApplicationMutation
  action :read do
    type Types::NotificationType

    argument :id, !types.ID
  end

  def read
    @notification = current_user.notifications.find_by(guid: params[:id])
    @notification.update read_at: Time.zone.now
    @notification
  end

  action :read_all do
    type Types::NotificationsCollectionType
  end

  def read_all
    @notifications = current_user.notifications
    @notifications.unread.update_all read_at: Time.zone.now
    @notifications
  end
end