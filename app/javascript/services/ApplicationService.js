import ApolloClient from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache } from 'apollo-cache-inmemory'
import fetch from 'node-fetch'

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

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
})

export default client
