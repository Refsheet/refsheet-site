import { subscribe } from 'services/ApplicationService'
import getConversations from './getConversations.graphql'
import subscribeToConversations from './subscribeToConversations.graphql'

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
  query: getConversations,
  subscription: subscribeToConversations,
  mapDataToProps,
  updateQuery,
})
