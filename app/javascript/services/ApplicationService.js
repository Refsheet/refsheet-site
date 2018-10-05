import ApolloClient from 'apollo-client'
import { ApolloLink } from 'apollo-link'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache } from 'apollo-cache-inmemory'
import fetch from 'node-fetch'
import ActionCable from 'actioncable'
import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink'

const cable = ActionCable.createConsumer()

const HOST = (
    window &&
    window.location &&
    window.location.origin
) || 'http://dev.refsheet.net:5000'

const httpLink = createHttpLink({
  uri: `${HOST}/graphql`,
  credentials: 'same-origin',
  fetch
})

const authLink = setContext((_, { headers }) => {
  return {
    headers: {
      ...headers,
      'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content,
      'Accept': 'application/json'
    }
  }
})

const hasSubscriptionOperation = ({ query: { definitions } }) => {
  return definitions.some(
      ({ kind, operation }) => kind === 'OperationDefinition' && operation === 'subscription'
  )
}

const link = ApolloLink.split(
    hasSubscriptionOperation,
    new ActionCableLink({cable}),
    httpLink
)

const client = new ApolloClient({
  link: authLink.concat(link),
  cache: new InMemoryCache()
})

export default client
