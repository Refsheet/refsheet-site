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

export const __globals = [
  'React',
  'ReactRouter',
  'PropTypes',
  'createReactClass',
  'ReactDOM',
  'Bowser',
  'Sentry',
    'qs',
    'createBrowserHistory'
]

export { default as React } from 'react'
export { default as PropTypes } from 'prop-types'
export { default as createReactClass } from 'create-react-class'
export { default as ReactDOM } from 'react-dom'
export { default as Bowser } from 'bowser'
export { default as qs } from 'query-string'
export { default as createBrowserHistory } from 'history/createBrowserHistory'
export { ReactRouter }
export { Sentry }

// NOT GLOBAL
export { default as V2Wrapper } from 'App'
export { default as Chat } from 'Chat/ConversationTray'
export { default as CharacterController } from 'App/Router'
export { default as NavBar } from 'NavBar'

(function() {
  console.log("Pack loaded: Refsheet JS v2")
  const event = new CustomEvent('jsload.pack')
  window.dispatchEvent(event)
})();

(function() {
  Sentry.init({
    dsn: Refsheet.sentryDsn,
    release: Refsheet.version,
    stage: Refsheet.environment
  })
})();
