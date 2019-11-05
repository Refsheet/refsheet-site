class Mutations::NotificationMutations < Mutations::ApplicationMutation
  action :read_all do
    type Types::NotificationsCollectionType
  end

  def read_all
    @notifications = current_user.notifications
    @notifications.unread.update_all read_at: Time.zone.now
    @notifications
  end
end