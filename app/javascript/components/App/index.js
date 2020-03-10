import React, { Component } from 'react'
import PropTypes from 'prop-types'

// Providers
import { ApolloProvider } from 'react-apollo'
import { Provider as ReduxProvider } from 'react-redux'
import DropzoneProvider from '../Dropzone'
import { ThemeProvider } from 'styled-components'
import { I18nextProvider } from 'react-i18next'

// Initialization
import reactGuard from 'react-guard'
import { createStore } from 'redux'
import rootReducer from 'reducers'
import client from 'ApplicationService'
import { createBrowserHistory } from 'history'
import i18n from '../../services/i18n.js'

// Utilities
import * as Sentry from '@sentry/browser'
import ReactGA from 'react-ga'
import WindowAlert from '../../utils/WindowAlert'
import StringUtils from 'utils/StringUtils'
import Flash from '../../utils/Flash'
import qs from 'query-string'

// Configuration
import defaultState from './defaultState.json'
import { base as defaultTheme } from 'themes/default'
import { base as debugTheme } from 'themes/debug'

// Children
import Layout from './Layout'
import { Router as BrowserRouter } from 'react-router-dom'

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
    const report = e => {
      e.preventDefault()
      Sentry.showReportDialog({ eventId })
    }

    return (
      <span className={'render-error'}>
        {errorString}
        <br />(
        <a onClick={report} href={'#bugreport'}>
          Report Bug?
        </a>
        )
      </span>
    )
  } else {
    return <span className={'render-error'}>{errorString}</span>
  }
})

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      theme: defaultTheme,
    }

    this.store = this.buildStore(this.buildState(props.state))
    this.history = this.buildHistory()

    this.initWindowAlert()
  }

  initWindowAlert() {
    const { assets } = this.props

    WindowAlert.initSound({
      notificationSoundPaths: assets.notificationSoundPaths,
    })
  }

  buildState(state = {}) {
    let {
      eagerLoad: { session = {} },
    } = this.props
    session = StringUtils.camelizeKeys(session)

    const newState = {
      ...defaultState,
      ...state,
      session: {
        ...defaultState.session,
        ...session,
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

    return newState
  }

  buildStore(state) {
    const store = createStore(rootReducer, state)
    console.debug('Initialized with state:', store.getState())

    return store
  }

  buildHistory() {
    const history = createBrowserHistory()

    const addLocationQuery = hist => {
      hist.location = Object.assign(hist.location, {
        query: qs.parse(hist.location.search),
      })
    }

    addLocationQuery(history)

    history.listen(() => {
      addLocationQuery(history)
    })

    return history
  }

  handleRouteUpdate() {
    if (this.props.gaPropertyID && typeof ReactGA !== 'undefined') {
      ReactGA.set({
        page: window.location.pathname,
      })

      ReactGA.pageview(window.location.pathname)
      // TODO: Deprecate jQuery and see if we need this?
      // $(document).trigger('navigate')
    }
  }

  componentDidMount() {
    this.unlisten = this.history.listen(this.handleRouteUpdate.bind(this))

    // Fade Out Loader
    const $loader = document.getElementById('rootAppLoader')
    $loader.style.opacity = 1
    ;(function fade() {
      ;($loader.style.opacity -= 0.1) < 0
        ? ($loader.style.display = 'none')
        : setTimeout(fade, 40)
    })()

    // Set Google Analytics
    if (this.props.gaPropertyId && typeof ReactGA !== 'undefined') {
      ReactGA.initialize(this.props.gaPropertyID)
      ReactGA.set({ page: window.location.pathname })
      ReactGA.pageview(window.location.pathname)
    }

    // Show Flashes
    if (this.props.flash) {
      for (const level in this.props.flash) {
        Flash.now(level, this.props.flash[level])
      }
    }
  }

  render() {
    return (
      <I18nextProvider i18n={i18n}>
        <ThemeProvider theme={this.state.theme}>
          <ApolloProvider client={client} store={this.store}>
            <ReduxProvider store={this.store}>
              <DropzoneProvider>
                <BrowserRouter
                  history={this.history}
                  onUpdate={this.handleRouteUpdate}
                >
                  <Layout />
                </BrowserRouter>
              </DropzoneProvider>
            </ReduxProvider>
          </ApolloProvider>
        </ThemeProvider>
      </I18nextProvider>
    )
  }
}

App.propTypes = {
  gaPropertyID: PropTypes.string,
  eagerLoad: PropTypes.object,
  flash: PropTypes.object,
  environment: PropTypes.string,
  notice: PropTypes.string,
  assets: PropTypes.object,
}

export default App