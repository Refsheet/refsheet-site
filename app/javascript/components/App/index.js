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
import { ThemeProvider } from 'styled-components'
import { base as defaultTheme } from 'themes/default'
import DropzoneProvider from '../Dropzone'

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

const App = ({children: propChildren, state}) => {
  const store = createStore(rootReducer, {...defaultState, ...state})
  console.log("Initialized with state:", store.getState())

  const children = propChildren || <Router />

  const theme = defaultTheme

  return (
      <ThemeProvider theme={ theme }>
        <ApolloProvider client={ client } store={store}>
          <ReduxProvider store={ store }>
            <DropzoneProvider>
              { children }
            </DropzoneProvider>
          </ReduxProvider>
        </ApolloProvider>
      </ThemeProvider>
  )
}

export default App
