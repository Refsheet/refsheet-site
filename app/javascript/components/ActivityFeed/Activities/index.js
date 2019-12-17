import React from 'react'
import StatusUpdate from './StatusUpdate'

export function getText(t, { activities, activityType }) {
  const count = activities ? activities.length : 1

  switch (activityType) {
    case 'Image':
      return t('activity.new-image', 'uploaded {{count}} image', { count })

    case 'Media::Comment':
      return t('activity.new-comment', 'commented on {{count}} image', {
        count,
      })

    case 'Character':
      return t('activity.new-character', 'created {{count}} new character', {
        count,
      })

    case 'Forum::Discussion':
      return t('activity.new-discussion', 'started {{count}} new discussion', {
        count,
      })
  }
}

export function render(props) {
  const { activity, activityType, comment } = props

  let { activities } = props

  if (!activities) activities = [activity]

  switch (activityType) {
    case 'Image':
      return (
        <Views.Account.Activities.Image
          images={activities}
          character={props.character}
        />
      )

    case 'Media::Comment':
      return <Views.Account.Activities.Comment comments={activities} />

    case 'Character':
      return (
        <Views.Account.Activities.Character
          characters={activities}
          username={props.user.username}
        />
      )

    case 'Forum::Discussion':
      return (
        <Views.Account.Activities.ForumDiscussion discussions={activities} />
      )

    default:
      return <StatusUpdate comment={comment} />
  }
}

export default render
