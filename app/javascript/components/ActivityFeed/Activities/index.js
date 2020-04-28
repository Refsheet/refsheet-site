import React from 'react'
import StatusUpdate from './StatusUpdate'
import Image from './Image'
import Comment from './Comment'
import Character from './Character'
import ForumDiscussion from './ForumDiscussion'

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
      return <Image images={activities} character={props.character} />

    case 'Media::Comment':
      return <Comment comments={activities} />

    case 'Character':
      return (
        <Character characters={activities} username={props.user.username} />
      )

    case 'Forum::Discussion':
      return <ForumDiscussion discussions={activities} />

    case null:
      return <StatusUpdate comment={comment} />

    default:
      return (
        <pre className={'card-content'}>
          {JSON.stringify(
            { activity, activities, activityType, comment },
            undefined,
            2
          )}
        </pre>
      )
  }
}

export default render
