// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import ShowAccount from '../../v1/views/account/show'
import ShowSettings from '../../v1/views/account/settings/show'

import ShowNotifications from './account/notifications/show'
import ExploreIndex from './explore/index'
const Views = {
  Account: {
    Show: ShowAccount,
    Settings: {
      Show: ShowSettings,
    },
    Notifications: {
      Show: ShowNotifications,
    },
  },
  Explore: {
    Index: ExploreIndex,
  },
  Character: {},
  Static: {},
}

export default Views
