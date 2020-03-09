/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'whatwg-fetch'
import * as Sentry from '@sentry/browser'
import * as ReactRouter from 'react-router-dom'
import * as UserUtils from 'utils/UserUtils'
import { setCurrentUser, setUploadTarget } from 'actions'
import * as Actions from 'actions'

export const __globals = [
  'React',
  'ReactRouter',
  'PropTypes',
  'createReactClass',
  'ReactDOM',
  'Bowser',
  'Sentry',
  'qs',
  'createBrowserHistory',
  'connect',
  'setCurrentUser',
  'setUploadTarget',
  'Actions',
  'NewLightbox',
  'Restrict',
  'UserUtils',
  'CommentForm',
  'LegacyForumReply',
  'StatusUpdate',
  'ActivityCard',
  'Materialize',
  'Footer',
]

export { default as React } from 'react'
export { default as PropTypes } from 'prop-types'
export { default as createReactClass } from 'create-react-class'
export { default as ReactDOM } from 'react-dom'
export { default as Bowser } from 'bowser'
export { default as qs } from 'query-string'
export { default as createBrowserHistory } from 'history/createBrowserHistory'
export { default as Materialize } from 'materialize-css'
export { connect } from 'react-redux'
export { ReactRouter }
export { Sentry }
export { setCurrentUser }
export { setUploadTarget }
export { Actions }
export { UserUtils }

// V1 Entrypoint
export { default as Routes } from 'v1/routes'

// NOT GLOBAL
export { default as V2Wrapper } from 'App'
export { default as Chat } from 'Chat/ConversationTray'
export { default as CharacterController } from 'App/Router'
export { default as NavBar } from 'NavBar'
export { default as DeleteUser } from 'Settings/Account/DeleteUser'
export { default as NewLightbox } from 'Lightbox'
export { default as UploadModal } from 'Image/UploadModal'
export { default as Restrict } from 'Shared/Restrict'
export { default as CommentForm } from 'ActivityFeed/StatusUpdate'
export { default as LegacyForumReply } from 'Forums/LegacyForumReply'
export { default as StatusUpdate } from 'ActivityFeed/Activities/StatusUpdate'
export { default as ActivityCard } from 'ActivityFeed/ActivityCard'
export { default as Footer } from 'Layout/Footer'
;(function() {
  console.log('Pack loaded: Refsheet JS v2')
  const event = new CustomEvent('jsload.pack')
  window.dispatchEvent(event)
})()
;(function() {
  if (Refsheet.environment === 'production') {
    Sentry.init({
      dsn: Refsheet.sentryDsn,
      release: Refsheet.version,
      stage: Refsheet.environment,
    })
  }
})()

// HOLIDAY THEME

import Snowflakes from 'magic-snowflakes'

try {
  document &&
    document.addEventListener('DOMContentLoaded', () => {
      if (window.location.hash === '#snow') {
        Snowflakes({
          color: '#80cbc4',
          minOpacity: 0.1,
          maxOpacity: 0.6,
          zIndex: 1,
          target: 'body',
        })
      }
    })
} catch (e) {
  // noop
}
