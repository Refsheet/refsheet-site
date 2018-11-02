import { gql } from 'apollo-client-preset'
import { subscribe } from 'ApplicationService'
import FIELDS from 'graphql/fragments/NotificationsFields.graphql'

const QUERY = gql`
    ${FIELDS}
    query getConversations {
        getNotifications {
            ...NotificationsFields
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

const mapDataToProps = (data) => ({
  notifications: data.getNotifications
})

const updateQuery = (prev, data) => {
  const { newConversation } = data

  return {
      ...prev,
      getNotifications: [
        ...prev.getNotifications,
        newConversation
      ]
  }
}

export default subscribe({
  query: QUERY,
  subscription: SUBSCRIPTION,
  mapDataToProps,
  updateQuery
})
