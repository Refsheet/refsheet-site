import React from 'react'
import { ApolloProvider } from 'react-apollo'
import { Provider as ReduxProvider } from 'react-redux'
import { createStore } from 'redux'
import reducers from 'reducers'
import Router from './Router'
import client from 'ApplicationService'

const App = () => {
  const store = createStore(reducers)

  return (
    <ApolloProvider client={ client }>
      <ReduxProvider store={ store }>
        <Router/>
      </ReduxProvider>
    </ApolloProvider>
  )
}

export default App
