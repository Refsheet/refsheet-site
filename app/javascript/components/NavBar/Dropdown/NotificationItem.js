import React from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import { Link } from 'react-router-dom'
import { timeDisplay } from 'Chat/ConversationMessage'
import { Icon } from 'react-materialize'

const NotificationItem = ({link = '#', icon, thumbnail, title, created_at, is_unread, floatTime, onClick}) => {
  const time = <div
      className={c('time muted', {right: floatTime})}
      title={timeDisplay(created_at, true)}
  >
    { timeDisplay(created_at || 0) }
  </div>

  return (
      <li className={c('notification-item', {unread: is_unread, fullbody: floatTime})}>
        <Link to={link} onClick={onClick}>
          { icon && <img src={icon} className='avatar' /> }
          <div className='body'>
            <div className='message'>
              { floatTime && time }
              { title || '???' }
            </div>
            { floatTime || time }
          </div>
          { thumbnail && <img src={thumbnail} className='subject' /> }
        </Link>
        <div className='menu'>
          <a href={'#'}><Icon>check</Icon></a>
          <a href={'#'}><Icon>more_vert</Icon></a>
        </div>
      </li>
  )
}

NotificationItem.propTypes = {}

export default NotificationItem
