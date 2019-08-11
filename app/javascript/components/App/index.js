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
import Lightbox from '../Lightbox'
import { I18nextProvider } from 'react-i18next'

import i18n from '../../services/i18n.js'

reactGuard(React, (error, componentInfo) => {
  const errorString = `Failed to render &lt;${componentInfo.name} /&gt;!`

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
  const newState = {
    ...defaultState,
    ...state,
    session: {
      ...defaultState.session,
      ...state.session
    }
  }

  if (!newState.session.identity.name) {
    newState.session.identity = {
      avatarUrl: newState.session.currentUser.avatar_url,
      name: newState.session.currentUser.name,
      characterId: null
    }
  }

  const store = createStore(rootReducer, newState)
  console.log("Initialized with state:", store.getState())

  const children = propChildren || <Router />

  const theme = defaultTheme

  return (
    <I18nextProvider i18n={i18n}>
      <ThemeProvider theme={ theme }>
        <ApolloProvider client={ client } store={store}>
          <ReduxProvider store={ store }>
            <DropzoneProvider>
              { children }
            </DropzoneProvider>
          </ReduxProvider>
        </ApolloProvider>
      </ThemeProvider>
    </I18nextProvider>
  )
}

export default App
