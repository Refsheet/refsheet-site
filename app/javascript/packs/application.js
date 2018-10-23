/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'whatwg-fetch'

export { default as V2Wrapper } from 'App'
export { default as Chat } from 'Chat'
export { default as CharacterController } from 'App/Router'
export { default as Bowser } from 'bowser'

(function() {
  console.log("Pack loaded: Refsheet JS v2")
  const event = new CustomEvent('jsload.pack')
  window.dispatchEvent(event)
})()
