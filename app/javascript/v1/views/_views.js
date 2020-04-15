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
import Layout from './account/layout'
import Activity from './account/_activity'
import User from './User'

import CharacterActivity from '../../components/ActivityFeed/Activities/Character'
import CommentActivity from '../../components/ActivityFeed/Activities/Comment'
import ForumDiscussionActivity from '../../components/ActivityFeed/Activities/ForumDiscussion'
import ForumPostActivity from '../../components/ActivityFeed/Activities/ForumPost'
import ImageActivity from '../../components/ActivityFeed/Activities/Image'

import Notifications from './account/settings/notifications'
import Support from './account/settings/support.js'

import Card from './account/notifications/_card'
import Feed from './account/notifications/_feed'
import ActivityCard from '../../components/ActivityFeed/ActivityCard'
import AccountUserCard from './account/_user_card'

import Suggestions from './account/_suggestions'
import SideNav from './account/_side_nav'

const Views = {
  Account: {
    Activities: {
      Character: CharacterActivity,
      Comment: CommentActivity,
      ForumDiscussion: ForumDiscussionActivity,
      ForumPost: ForumPostActivity,
      Image: ImageActivity,
    },
    Show: ShowAccount,
    Settings: {
      Show: ShowSettings,
      Notifications,
      Support,
    },
    Notifications: {
      Show: ShowNotifications,
      Card,
      Feed,
    },
    Layout,
    Activity,
    UserCard: AccountUserCard,
    Suggestions,
    SideNav,
    ActivityCard,
  },
  Explore: {
    Index: ExploreIndex,
  },
  User,
  Character: {
    //Attributes
  },
  Static: {},
  Images: {
    // ReportModal
  },
}

export default Views
