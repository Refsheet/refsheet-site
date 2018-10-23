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
import * as Refsheet from '../version.js.erb'

export const __globals = [
  'React',
  'ReactRouter',
  'PropTypes',
  'createReactClass',
  'ReactDOM',
  'Bowser',
  'Sentry',
  'Refsheet'
]

export { default as React } from 'react'
export { default as PropTypes } from 'prop-types'
export { default as createReactClass } from 'create-react-class'
export { default as ReactDOM } from 'react-dom'
export { default as V2Wrapper } from 'App'
export { default as Chat } from 'Chat'
export { default as CharacterController } from 'App/Router'
export { default as Bowser } from 'bowser'
export { Sentry, Refsheet }

(function() {
  console.log("Pack loaded: Refsheet JS v2")
  const event = new CustomEvent('jsload.pack')
  window.dispatchEvent(event)
})()

Sentry.init({
  dsn: Refsheet.sentryDsn,
  release: Refsheet.version,
  stage: Refsheet.environment
});
