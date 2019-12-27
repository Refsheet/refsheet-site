import { gql } from 'apollo-client-preset'
import { subscribe } from 'ApplicationService'
import FIELDS from 'graphql/fragments/ConversationsFields.graphql'

const QUERY = gql`
  ${FIELDS}
  query getConversations {
    getConversations {
      ...ConversationsFields
    }
  }
`
const SUBSCRIPTION = gql`
  ${FIELDS}
  subscription subscribeToConversations {
    newConversation {
      ...ConversationsFields
    }
  }
`

const mapDataToProps = data => ({
  conversations: data.getConversations,
})

const updateQuery = (prev, data) => {
  const { newConversation } = data

  return {
    ...prev,
    getConversations: [...prev.getConversations, newConversation],
  }
}

export default subscribe({
  query: QUERY,
  subscription: SUBSCRIPTION,
  mapDataToProps,
  updateQuery,
})
