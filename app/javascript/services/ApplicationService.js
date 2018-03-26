import ApolloClient from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { setContext } from 'apollo-link-context'
import { InMemoryCache } from 'apollo-cache-inmemory'

const httpLink = createHttpLink({
  uri: '/graphql',
  credentials: 'same-origin'
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

// defaultOptions = ->
//   headers: {
//     'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
//     'Content-Type': 'application/json'
//     'Accept': 'application/json'
//     'X-Requested-With': 'XMLHttpRequest'
//   }
//   credentials: 'same-origin'

const client = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
})

export default client
