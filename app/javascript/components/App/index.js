import React, { Component, createContext } from 'react'
import PropTypes from 'prop-types'

// Providers
import { ApolloProvider } from 'react-apollo'
import { Provider as ReduxProvider } from 'react-redux'
import DropzoneProvider from '../Dropzone'
import { I18nextProvider } from 'react-i18next'
import { HTML5Backend as Backend } from 'react-dnd-html5-backend'
import { DndProvider } from 'react-dnd'

// Initialization
import { createStore } from 'redux'
import rootReducer from 'reducers'
import client, { host } from 'services/ApplicationService'
import { createBrowserHistory } from 'history'
import i18n from '../../services/i18n.js'

// Utilities
import ReactGA from 'react-ga'
import WindowAlert from '../../utils/WindowAlert'
import StringUtils from 'utils/StringUtils'
import Flash from '../../utils/Flash'
import qs from 'query-string'

// Configuration
import defaultState from './defaultState.json'
import ConfigContext from './ConfigContext'

// Children
import Layout from '../Layout'
import { Router as BrowserRouter } from 'react-router-dom'
import { withErrorBoundary } from '../Shared/ErrorBoundary'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      eagerLoad: props.eagerLoad,
      config: {
        ...props.config,
        loading: false,
      },
    }

    this.store = this.buildStore(this.buildState(props.state))
    this.history = this.buildHistory()

    // Set Google Analytics
    if (props.gaPropertyID && typeof ReactGA !== 'undefined') {
      ReactGA.initialize(this.props.gaPropertyID)

      ReactGA.set({ page: window.location.pathname })
      ReactGA.pageview(window.location.pathname)
    }

    this.initWindowAlert()
  }

  initWindowAlert() {
    const { assets } = this.props

    WindowAlert.initSound({
      notificationSoundPaths: assets.notificationSoundPaths,
    })
  }

  buildState(state = {}) {
    let session = (this.props.eagerLoad && this.props.eagerLoad.session) || {}
    session = StringUtils.camelizeKeys(session)

    let theme =
      (session.currentUser && session.currentUser.settings.theme) || {}
    theme = StringUtils.camelizeKeys(theme)

    const newState = {
      ...defaultState,
      ...state,
      session: {
        ...defaultState.session,
        ...session,
        ...state.session,
      },
      theme: {
        ...defaultState.theme,
        ...theme,
      },
    }

    console.log({ newState })

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
    }
  }

  componentDidMount() {
    this.unlisten = this.history.listen(this.handleRouteUpdate.bind(this))

    console.debug('App mounted with props: ', this.props)

    // Fade Out Loader
    const $loader = document.getElementById('rootAppLoader')
    $loader.style.opacity = 1
    ;(function fade() {
      ;($loader.style.opacity -= 0.1) < 0
        ? ($loader.style.display = 'none')
        : setTimeout(fade, 40)
    })()

    // Show Flashes
    if (this.props.flash) {
      Object.keys(this.props.flash).map(level => {
        const flash = this.props.flash[level]
        console.log('Flash[' + level + ']: ' + flash)
        Flash.now(level, flash)
      })
    }

    // Clear Eager Load
    this.setState({ eagerLoad: null })
  }

  render() {
    return (
      <ConfigContext.Provider value={this.state.config}>
        <I18nextProvider i18n={i18n}>
          <ApolloProvider client={client} store={this.store}>
            <ReduxProvider store={this.store}>
              <DropzoneProvider>
                <DndProvider backend={Backend}>
                  <BrowserRouter
                    history={this.history}
                    onUpdate={this.handleRouteUpdate}
                  >
                    <Layout />
                  </BrowserRouter>
                </DndProvider>
              </DropzoneProvider>
            </ReduxProvider>
          </ApolloProvider>
        </I18nextProvider>
      </ConfigContext.Provider>
    )
  }

  // TODO: Find which components are using this and send them to Redux.
  getChildContext() {
    return {
      eagerLoad: this.state.eagerLoad,
    }
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

App.childContextTypes = {
  eagerLoad: PropTypes.object,
}

export default withErrorBoundary(App)
