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

  return {
      ...prev,
      getNotifications: {
        ...prev.getNotifications,
        notifications: [
          ...prev.getNotifications.notifications,
          newNotification
        ]
      }
  }
}

export default subscribe({
  query: QUERY,
  subscription: SUBSCRIPTION,
  mapDataToProps,
  updateQuery
})
