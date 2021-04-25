import React from 'react'
import PropTypes from 'prop-types'
import { Route, Switch } from 'react-router-dom'
import { Redirect } from 'react-router'

import NotFound from '../Shared/views/NotFound'
import Loading from '../Shared/views/Loading'
import Character from '../Character'
import Moderate from '../Moderate'
import Forums from '../Forums'
import Forum from '../Forums/Forum'
import Artists from '../Artists'
import Home from '../../v1/views/static/Home'
import LoginView from '../../v1/views/sessions/LoginView'
import RegisterView from '../../v1/views/sessions/RegisterView'
import BrowseApp from '../../v1/views/browse/BrowseApp'
import Views from '../../v1/views/_views'
import ImageApp from '../../v1/views/images/ImageApp'
import Static from '../../v1/views/Static'
import CharacterApp from '../../v1/views/characters/CharacterApp'
import User from 'v1/views/User'
import { withErrorBoundary } from '../Shared/ErrorBoundary'
import Site from '../Settings/Site'
import API from '../Settings/API'

const staticPaths = ['privacy', 'terms', 'support'].map(path => (
  <Route key={path} path={'/' + path} component={Static.View} />
))

const Routes = () => (
  <Switch>
    <Route exact path="/" component={Home} title="Home" />

    {/** Forums **/}
    <Redirect from={'/v2/forums/:id'} to={'/forums/:id'} />
    <Redirect from={'/v2/forums'} to={'/forums'} />
    <Route path={'/forums/:id'} component={Forum} />
    <Route path={'/forums'} component={Forums} />

    {/** Moderation **/}
    <Route path="/moderate" component={Moderate} />

    {/** Artists **/}
    <Route path={'/artists/:slug'} component={Artists.Show} />
    <Route path={'/artists'} component={Artists.Index} />

    {/** Account **/}
    <Route path="/myrefs/new" component={Loading} />
    <Route path="/myrefs" component={Loading} />

    {/** V1 **/}

    <Route path="/login" component={LoginView} />
    <Route path="/register" component={RegisterView} />

    <Route
      path="/account"
      title="Account"
      render={props2 => (
        <Views.Account.Layout {...props2}>
          <Switch>
            <Redirect exact from="/account" to="/account/settings" />
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
            <Route path="/account/api_keys" title="API Keys" component={API} />
          </Switch>
        </Views.Account.Layout>
      )}
    />

    <Route
      path="/notifications"
      title="Notifications"
      component={Views.Account.Notifications.Show}
    />

    <Route path="/browse" component={BrowseApp} />
    <Route path="/explore/:scope?" component={Views.Explore.Index} />

    {/*== Static Routes */}

    {staticPaths}
    <Route path="/static/:pageId" component={Static.View} />

    {/*== Profile Content */}

    <Route path="/images/:imageId" component={ImageApp} />
    <Route path="/media/:imageId" component={ImageApp} />

    {/** Character Profiles **/}
    <Route path="/v2/:username/:slug" component={Character} />
    <Route path="/:userId/:characterId" component={CharacterApp} />
    <Route path="/:userId" component={User} />

    {/*== Fallback */}

    <Route path="*" component={NotFound} />
  </Switch>
)

Routes.propTypes = {}

export default withErrorBoundary(Routes)
