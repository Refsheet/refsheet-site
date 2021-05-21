/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS205: Consider reworking code to avoid use of IIFEs
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import { Router, Redirect, Switch, Route, Link } from 'react-router-dom'
import createBrowserHistory from 'history/createBrowserHistory'
import qs from 'querystring'
import ReactGA from 'react-ga'

import App from '../components/App'
import LegacyApp from './views/_App'
import Static from '../v1/views/Static'
import StringUtils from '../v1/utils/StringUtils'
import LoginView from '../v1/views/sessions/LoginView'
import RegisterView from '../v1/views/sessions/RegisterView'
import Views from '../v1/views/_views'
import BrowseApp from './views/browse/BrowseApp'
import Forums from './views/Forums'
import ImageApp from './views/images/ImageApp'
import CharacterApp from './views/characters/CharacterApp'
import * as Materialize from 'materialize-css'
import User from './views/User'

import $ from 'jquery'
import Site from '../components/Settings/Site'
import API from '../components/Settings/API'

// Backfill for Router V4 not parsing query strings.
const history = createBrowserHistory()
function addLocationQuery(history) {
  history.location = Object.assign(history.location, {
    query: qs.parse(history.location.search),
  })
}

addLocationQuery(history)

history.listen(() => {
  addLocationQuery(history)
})

const Routes = createReactClass({
  propTypes: {
    gaPropertyID: PropTypes.string,
    eagerLoad: PropTypes.object,
    flash: PropTypes.object,
  },

  componentDidMount() {
    console.log(`Loading ${this.props.environment} environment.`)

    this.unlisten = history.listen(() => {
      return this._handleRouteUpdate()
    })

    $(() => $('#rootAppLoader').fadeOut(300))

    if (this.props.gaPropertyID) {
      ReactGA.initialize(this.props.gaPropertyID)
      ReactGA.set({ page: window.location.pathname })
      ReactGA.pageview(window.location.pathname)
    }

    if (this.props.flash) {
      for (var level in this.props.flash) {
        const message = this.props.flash[level]
        const color = (() => {
          switch (level) {
            case 'error':
              return 'red'
            case 'warn':
              return 'yellow darken-1'
            case 'notice':
              return 'green'
            default:
              return 'grey darken-2'
          }
        })()

        Materialize.toast({
          html: message,
          displayLength: 3000,
          classes: color,
        })
      }
    }
  },

  _handleRouteUpdate() {
    if (this.props.gaPropertyID) {
      ReactGA.set({ page: window.location.pathname })
      ReactGA.pageview(window.location.pathname)
    }

    return $(document).trigger('navigate')
  },

  render() {
    const staticPaths = ['privacy', 'terms', 'support'].map(path => (
      <Route key={path} path={'/' + path} component={Static.View} />
    ))

    const router = (
      <Router history={history} onUpdate={this._handleRouteUpdate}>
        <Switch>
          <Route
            path="/"
            render={props => (
              <LegacyApp
                {...props}
                eagerLoad={this.props.eagerLoad}
                environment={this.props.environment}
                notice={this.props.notice}
              >
                <Switch>
                  <Route exact path="/" component={Static.Home} title="Home" />

                  <Route path="/login" component={LoginView} />
                  <Route path="/register" component={RegisterView} />

                  <Route
                    path="/account"
                    title="Account"
                    render={props2 => (
                      <Views.Account.Layout {...props2}>
                        <Switch>
                          <Redirect
                            exact
                            from="/account"
                            to="/account/settings"
                          />
                          <Route
                            path="/account/settings"
                            title="Account Settings"
                            component={Views.Account.Settings.Show}
                          />
                          <Route
                            path="/account/site"
                            title="Site Settings"
                            component={Site}
                          />
                          <Route
                            path="/account/support"
                            title="Support Settings"
                            component={Views.Account.Settings.Support}
                          />
                          <Route
                            path="/account/notifications"
                            title="Notification Settings"
                            component={Views.Account.Settings.Notifications}
                          />
                          <Route
                            path="/account/api_keys"
                            title="API Keys"
                            component={API}
                          />
                        </Switch>
                      </Views.Account.Layout>
                    )}
                  />

                  <Route path="/myrefs" component={App} />
                  <Route path="/myrefs/new" component={App} />

                  <Route path="/moderate" component={App} />

                  <Route
                    path="/notifications"
                    title="Notifications"
                    component={Views.Account.Notifications.Show}
                  />

                  <Route path="/browse" component={BrowseApp} />
                  <Route
                    path="/explore/:scope?"
                    component={Views.Explore.Index}
                  />

                  <Route path="/forums">
                    <Switch>
                      <Route exact path="/forums" component={Forums.Index} />

                      <Route
                        path="/forums/:forumId"
                        render={props2 => (
                          <Forums.Show {...props2}>
                            <Route
                              path="/forums/:forumId/:threadId"
                              component={Forums.Threads.Show}
                            />
                          </Forums.Show>
                        )}
                      />
                    </Switch>
                  </Route>

                  <Route path="/forums" component={App} />

                  <Route path="/artists" component={App} />
                  <Route path="/artists/:slug" component={App} />

                  {/*== Static Routes */}

                  {staticPaths}
                  <Route path="/static/:pageId" component={Static.View} />

                  {/*== Profile Content */}

                  <Route path="/v2/:userId/:characterId" component={App} />

                  <Route path="/images/:imageId" component={ImageApp} />
                  <Route path="/media/:imageId" component={ImageApp} />
                  <Route
                    path="/:userId/:characterId"
                    component={CharacterApp}
                  />
                  <Route path="/:userId" component={User.View} />

                  {/*== Fallback */}

                  <Route path="*" component={App} />
                </Switch>
              </LegacyApp>
            )}
          />
        </Switch>
      </Router>
    )

    const session =
      (this.props.eagerLoad != null
        ? this.props.eagerLoad.session
        : undefined) || {}

    const defaultState = {
      session: StringUtils.camelizeKeys(session),
    }

    return (
      <App state={defaultState} assets={this.props.assets}>
        {router}
      </App>
    )
  },
})

// export default Routes
export default function DeprecatedRouter() {
  return <h1>Deprecated Routes!!!</h1>
}
