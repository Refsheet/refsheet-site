/* global Refsheet */

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
import $ from 'jquery'

// TODO: Kill this after jQuery fetching is disabled.
$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
  },
})

if (Refsheet.environment === 'production') {
  Sentry.init({
    dsn: Refsheet.sentryDsn,
    release: Refsheet.version,
    stage: Refsheet.environment,
  })
}

//== V2 Init Code
import React from 'react'
import ReactDOM from 'react-dom'
import App from '../components/App'

function init(id, props) {
  ReactDOM.render(<App {...props} />, document.getElementById(id))
}

export { init }

window._jsV2 = true
console.log('Pack loaded: Refsheet JS v2')
const event = new CustomEvent('jsload.pack')
window.dispatchEvent(event)
