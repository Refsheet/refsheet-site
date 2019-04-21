import ApolloClient from 'apollo-client'
import { ApolloLink } from 'apollo-link'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache, IntrospectionFragmentMatcher } from 'apollo-cache-inmemory'
import fetch from 'node-fetch'
import ActionCable from 'actioncable'
import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink'
import introspectionQueryResultData from '../config/fragmentTypes.json'

const cable = ActionCable.createConsumer()

const HOST = (
    window &&
    window.location &&
    window.location.origin
) || 'http://dev1.refsheet.net:5000'

const fragmentMatcher = new IntrospectionFragmentMatcher({
  introspectionQueryResultData
})

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

const defaultOptions = {
  watchQuery: {
    fetchPolicy: 'network-only',
    errorPolicy: 'ignore'
  },
  query: {
    fetchPolicy: 'network-only',
    errorPolicy: 'all'
  },
  mutate: {
    errorPolicy: 'all'
  }
}

const cache = new InMemoryCache({
  fragmentMatcher
})

export const client = new ApolloClient({
  link: authLink.concat(link),
  cache: cache,
  defaultOptions
})

export { default as subscribe } from './buildSubscriptionRender'

export default client
