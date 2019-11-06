import { gql } from 'apollo-client-preset'
import { subscribe } from 'ApplicationService'
import FIELDS from 'graphql/fragments/NotificationsFields.graphql'

const QUERY = gql`
    ${FIELDS}
    query getConversations {
        getNotifications {
            unreadCount,
            notifications {
                ...NotificationsFields
            }
        }
    }
`
const SUBSCRIPTION = gql`
    ${FIELDS}
    subscription subscribeToNotifications {
        newNotification {
            ...NotificationsFields
        }
    }
`

const mapDataToProps = ({getNotifications = {}}) => ({
  notifications: getNotifications.notifications,
  unreadCount: getNotifications.unreadCount
})

const updateQuery = (prev, data) => {
  const { newNotification } = data

  const notifications = [
    newNotification,
    ...prev.getNotifications.notifications.filter(n => n.id !== newNotification.id)
  ]

  const unreadCount = notifications.filter(n => n.is_unread).length

  return {
      ...prev,
      getNotifications: {
        ...prev.getNotifications,
        unreadCount,
        notifications
      }
  }
}

export default subscribe({
  query: QUERY,
  subscription: SUBSCRIPTION,
  mapDataToProps,
  updateQuery
})
