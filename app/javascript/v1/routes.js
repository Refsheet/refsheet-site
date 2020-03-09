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
import Static from '../v1/views/Static'

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
              <App
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
                            path="/account/support"
                            title="Support Settings"
                            component={Views.Account.Settings.Support}
                          />
                          <Route
                            path="/account/notifications"
                            title="Notification Settings"
                            component={Views.Account.Settings.Notifications}
                          />
                        </Switch>
                      </Views.Account.Layout>
                    )}
                  />

                  <Route
                    path="/myrefs"
                    component={Packs.application.CharacterController}
                  />
                  <Route
                    path="/myrefs/new"
                    component={Packs.application.CharacterController}
                  />

                  <Route
                    path="/moderate"
                    component={Packs.application.CharacterController}
                  />

                  <Route
                    path="/notifications"
                    title="Notifications"
                    component={Views.Account.Notifications.Show}
                  />

                  <Route path="/browse" component={BrowseApp} />
                  <Route path="/explore/:scope?" component={Explore.Index} />

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

                  <Route
                    path="/v2/forums"
                    component={Packs.application.CharacterController}
                  />

                  <Route
                    path="/artists"
                    component={Packs.application.CharacterController}
                  />
                  <Route
                    path="/artists/:slug"
                    component={Packs.application.CharacterController}
                  />

                  {/*== Static Routes */}

                  {staticPaths}
                  <Route path="/static/:pageId" component={Static.View} />

                  {/*== Profile Content */}

                  <Route
                    path="/v2/:userId/:characterId"
                    component={Packs.application.CharacterController}
                  />

                  <Route path="/images/:imageId" component={ImageApp} />
                  <Route path="/media/:imageId" component={ImageApp} />
                  <Route
                    path="/:userId/:characterId"
                    component={CharacterApp}
                  />
                  <Route path="/:userId" component={User.View} />

                  {/*== Fallback */}

                  <Route
                    path="*"
                    component={Packs.application.CharacterController}
                  />
                </Switch>
              </App>
            )}
          ></Route>
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
      <Packs.application.V2Wrapper
        state={defaultState}
        assets={this.props.assets}
      >
        {router}
      </Packs.application.V2Wrapper>
    )
  },
})

export default Routes
