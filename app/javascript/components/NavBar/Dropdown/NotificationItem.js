import React from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import { Link } from 'react-router-dom'
import { timeDisplay } from 'Chat/ConversationMessage'
import { Icon } from 'react-materialize'

/*
 * For the onClick, onMoreClick, and onDismiss handlers, if a Promise is
 * returned we assume it's a GraphQL mutation call, and will call the
 * refetch handler if provided. Promise catches go to console.error.
 */
const NotificationItem = props => {
  const {
    id,
    link = '#',
    icon,
    dismissIcon,
    thumbnail,
    title,
    created_at,
    is_unread,
    floatTime,
    onClick,
    onMoreClick,
    onDismiss,
    refetch,
  } = props

  let time

  if (created_at) {
    time = (
      <div
        className={c('time muted', { right: floatTime })}
        title={timeDisplay(created_at, true)}
      >
        {timeDisplay(created_at || 0)}
      </div>
    )
  } else {
    time = null
  }

  const more = e => {
    if (!onMoreClick) return

    e.preventDefault()

    const result = onMoreClick({
      variables: {
        id: id,
      },
    })

    if (result && result.then) {
      result
        .then(data => {
          if (data && refetch) refetch()
        })
        .catch(console.error)
    }
  }

  const dismiss = e => {
    if (!onDismiss) return

    e.preventDefault()

    const result = onDismiss({
      variables: {
        id: id,
      },
    })

    if (result && result.then) {
      result
        .then(data => {
          if (data && refetch) refetch()
        })
        .catch(console.error)
    }
  }

  const click = e => {
    if (!onClick) return

    e.preventDefault()

    const result = onClick({
      variables: {
        id: id,
      },
    })

    if (result && result.then) {
      result
        .then(data => {
          if (data && refetch) refetch()
        })
        .catch(console.error)
    }
  }

  if (!link) {
    return null
  }

  return (
    <li
      className={c('notification-item', {
        unread: is_unread,
        fullbody: floatTime,
      })}
    >
      <Link to={link} onClick={click}>
        {icon && <img src={icon} className="avatar" />}
        <div className="body">
          <div className="message">
            {floatTime && time}
            {title || '???'}
          </div>
          {floatTime || time}
        </div>
        {thumbnail && <img src={thumbnail} className="subject" />}
      </Link>
      <div className="menu">
        {onDismiss && is_unread && (
          <a href={'#'} onClick={dismiss}>
            <Icon>{dismissIcon || 'check'}</Icon>
          </a>
        )}
        {onMoreClick && (
          <a href={'#'} onClick={more}>
            <Icon>more_vert</Icon>
          </a>
        )}
      </div>
    </li>
  )
}

NotificationItem.propTypes = {}

export default NotificationItem
