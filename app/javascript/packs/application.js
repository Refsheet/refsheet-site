/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

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
  'Link',
  'StringUtils',
]

export { default as React } from 'react'
export { default as PropTypes } from 'prop-types'
export { default as createReactClass } from 'create-react-class'
export { default as ReactDOM } from 'react-dom'
export { default as Bowser } from 'bowser'
export { Link } from 'react-router-dom'
export { default as qs } from 'query-string'
export { default as createBrowserHistory } from 'history/createBrowserHistory'
export { default as Materialize } from 'materialize-css'
export { connect } from 'react-redux'
export { ReactRouter }
export { setCurrentUser }
export { setUploadTarget }
export { Actions }
export { UserUtils }
export { default as StringUtils } from 'utils/StringUtils'

// NOT GLOBAL
export { default as V2Wrapper } from 'App'
export { default as Chat } from 'Chat/ConversationTray'
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

//== V2 Init Code

import React from 'react'
import ReactDOM from 'react-dom'
import App from '../components/App'
import * as Sentry from '@sentry/browser'
import '../sass/index.sass'

// Polyfills
import 'whatwg-fetch'

function initSentry(refsheet) {
  if (refsheet.environment === 'production') {
    Sentry.init({
      dsn: refsheet.sentryDsn,
      release: refsheet.version,
      stage: refsheet.environment,
    })
  }
}

function init(id, props, refsheet) {
  initSentry(refsheet)
  ReactDOM.render(<App {...props} />, document.getElementById(id))
}

export { Sentry, init }

if (1 == 1)
  // Force render
  console.log('did')
