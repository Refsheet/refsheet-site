import React from 'react'
import PropTypes from 'prop-types'

const NotificationItem = ({}) => {
  return (
      <li className='notification-item'>
        <a href={'#'}>
          <img src={'https://placehold.it/250'} className='avatar' />
          <div className='body'>
            <div className='message'>
              <strong>Mau Abata</strong> commented on <strong>Image of Shabti</strong>.
            </div>
            <div className='time muted'>19h</div>
          </div>
          <img src={'https://placehold.it/320'} className='subject' />
        </a>
      </li>
  )
}

NotificationItem.propTypes = {}

export default NotificationItem
