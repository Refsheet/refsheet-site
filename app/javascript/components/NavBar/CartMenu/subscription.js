import { subscribe } from 'ApplicationService'
import getCart from './getCart.graphql'
import subscribeToCart from './subscribeToCart.graphql'

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
  query: getCart,
  subscription: subscribeToCart,
  mapDataToProps,
  updateQuery,
})
