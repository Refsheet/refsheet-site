import React from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import { Link } from 'react-router-dom'
import { timeDisplay } from 'Chat/ConversationMessage'

const NotificationItem = ({link = '#', icon, thumbnail, title, created_at, is_unread}) => {
  return (
      <li className={c('notification-item', {unread: is_unread})}>
        <Link to={link}>
          { icon && <img src={icon} className='avatar' /> }
          <div className='body'>
            <div className='message'>
              { title || '???' }
            </div>
            <div className='time muted' title={timeDisplay(created_at, true)}>
              {timeDisplay(created_at || 0)}
            </div>
          </div>
          { thumbnail && <img src={thumbnail} className='subject' /> }
        </Link>
      </li>
  )
}

NotificationItem.propTypes = {}

export default NotificationItem
