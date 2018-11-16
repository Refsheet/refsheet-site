import { gql } from 'apollo-client-preset'
import { subscribe } from 'ApplicationService'
import FIELDS from 'graphql/fragments/TransfersFields.graphql'

const QUERY = gql`
    ${FIELDS}
    query getConversations {
        getTransfers {
            ...TransfersFields
        }
    }
`
const SUBSCRIPTION = gql`
    ${FIELDS}
    subscription subscribeToTransfers {
        newNotification {
            ...TransfersFields
        }
    }
`

const mapDataToProps = (data) => ({
  transfers: data.getTransfers
})

const updateQuery = (prev, data) => {
  const { newConversation } = data

  return {
      ...prev,
      getTransfers: [
        ...prev.getTransfers,
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
