import React from 'react'
import reactGuard from 'react-guard'
import { ApolloProvider } from 'react-apollo'
import { Provider as ReduxProvider } from 'react-redux'
import { createStore } from 'redux'
import rootReducer from 'reducers'
import Router from './Router'
import client from 'ApplicationService'
import * as Sentry from '@sentry/browser'
import defaultState from './defaultState.json'

reactGuard(React, (error, componentInfo) => {
  const errorString = `Failed to render <${componentInfo.name} />!`

  if (console && console.error) {
    console.error(errorString, componentInfo)
    console.error(error.stack)

    if(Sentry) {
      Sentry.captureException(error)
    }
  }

  return <span>{errorString}</span>
})

const App = ({children: propChildren}) => {
  const store = createStore(rootReducer, defaultState)

  const children = propChildren || <Router />

  return (
    <ApolloProvider client={ client } store={store}>
      <ReduxProvider store={ store }>
        { children }
      </ReduxProvider>
    </ApolloProvider>
  )
}

export default App
