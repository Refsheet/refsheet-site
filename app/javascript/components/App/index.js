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
import WindowAlert from '../../utils/WindowAlert'

reactGuard(React, (error, componentInfo) => {
  const errorString = `Failed to render <${componentInfo.displayName} />!`
  let eventId = null

  if (console && console.error) {
    console.error(error)
    console.error(errorString, componentInfo)
    console.error(error.stack)
  }

  if (Sentry) {
    eventId = Sentry.captureException(error)
  }

  if (eventId) {
    const report = (e) => {
      e.preventDefault()
      Sentry.showReportDialog({ eventId })
    }

    return <span className={'render-error'}>{errorString}<br />(<a onClick={report} href={'#bugreport'}>Report Bug?</a>)</span>
  } else {
    return <span className={'render-error'}>{errorString}</span>
  }
})

const App = ({ children: propChildren, state, assets }) => {
  const newState = {
    ...defaultState,
    ...state,
    session: {
      ...defaultState.session,
      ...state.session,
    },
  }

  if (!newState.session.identity.name && newState.session.currentUser) {
    newState.session.identity = {
      avatarUrl: newState.session.currentUser.avatar_url,
      name: newState.session.currentUser.name,
      characterId: null,
    }
  }

  WindowAlert.initSound({
    notificationSoundPaths: assets.notificationSoundPaths,
  })

  const store = createStore(rootReducer, newState)
  console.debug('Initialized with state:', store.getState())

  const children = propChildren || <Router />

  const theme = defaultTheme

  return (
    <I18nextProvider i18n={i18n}>
      <ThemeProvider theme={theme}>
        <ApolloProvider client={client} store={store}>
          <ReduxProvider store={store}>
            <DropzoneProvider>{children}</DropzoneProvider>
          </ReduxProvider>
        </ApolloProvider>
      </ThemeProvider>
    </I18nextProvider>
  )
}

export default App
