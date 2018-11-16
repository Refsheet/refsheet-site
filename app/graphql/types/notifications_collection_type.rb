Types::NotificationsCollectionType = GraphQL::ObjectType.define do
  name "NotificationCollection"

  field :unreadCount, types.Int do
    resolve -> (obj, _args, _ctx) {
      obj.unread.count
    }
  end

  field :notifications, types[Types::NotificationType] do
    resolve -> (obj, _args, _ctx) {
      obj.default_sort.eager_loaded
    }
  end
end
