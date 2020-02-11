import React from 'react'

// Helper for re-importing V1 code
function v1(componentName) {
  return props => {
    const path = componentName.split('.')
    let component = window

    path.map(entry => {
      component = component && component[entry]
    })

    console.warn(
      `Use of "${componentName}" from V1 javascript package ` +
      'is deprecated. Please migrate this component to V2 or stop using it. ' +
      '(See Shared/V1.js for details and re-exports.)'
    )

    console.debug('Resolved ' + componentName + ' to ', component)

    if (component) {
      return React.createElement(component, props)
    } else {
      return <div>{componentName} not found in V1?</div>
    }
  }
}

// Define V1 imports here, turning them into factories which can be resolved
// at runtime. There is a helper for this which will print a deprecation warning.
// See existing examples for details.

const Modal = v1('Modal')
const Loading = v1('Loading')
const App = v1('App')
const Home = v1('Home')
const LoginView = v1('LoginView')
const RegisterView = v1('RegisterView')
const BrowseApp = v1('BrowseApp')
const ImageApp = v1('ImageApp')
const CharacterApp = v1('CharacterApp')
const SessionModal = v1('SessionModal')

const User = {
  View: v1('User'),
}

const Static = {
  View: v1('Static.View'),
}

const Forums = {
  Index: v1('Forums.Index'),
  Threads: {
    Show: v1('Forums.Threads.Show'),
  },
}

const Explore = {
  Index: v1('Explore.Index'),
}

const Views = {
  Account: {
    Settings: {
      Show: v1('Views.Account.Settings.Show'),
      Support: v1('Views.Account.Settings.Support'),
      Notifications: v1('Views.Account.Settings.Notifications'),
    },
    Notifications: {
      Show: v1('Views.Account.Notifications.Show'),
    },
  },
}

export {
  Modal,
  Loading,
  App,
  Home,
  LoginView,
  RegisterView,
  Views,
  BrowseApp,
  Explore,
  Forums,
  Static,
  ImageApp,
  CharacterApp,
  User,
  SessionModal,
}