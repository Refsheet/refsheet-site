import React from 'react'

function v1(component) {
  return () => {
    throw "Don't export: " + component
  }
}

export { default as Modal } from '../../v1/shared/Modal'
export { default as Loading } from '../../v1/shared/Loading'
export { default as App } from '../../v1/views/_App'

const Home = v1('Home')
const LoginView = v1('LoginView')
const RegisterView = v1('RegisterView')
const BrowseApp = v1('BrowseApp')
const ImageApp = v1('ImageApp')
const CharacterApp = v1('CharacterApp')

export { default as SessionModal } from '../../v1/shared/modals/SessionModal'

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
}
