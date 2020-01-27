import { subscribe } from 'ApplicationService'
import getTransfers from './getTransfers.graphql'
import SubscribeToTransfers from './subscribeToTransfers.graphql'

const mapDataToProps = data => ({
  transfers: data.getTransfers,
})

const updateQuery = (prev, data) => {
  const { newConversation } = data

  return {
    ...prev,
    getTransfers: [...prev.getTransfers, newConversation],
  }
}

export default subscribe({
  query: getTransfers,
  subscription: subscribeToTransfers,
  mapDataToProps,
  updateQuery,
})
