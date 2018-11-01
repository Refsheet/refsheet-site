import React from 'react'
import PropTypes from 'prop-types'
import DropdownLink from './DropdownLink'
import NotificationItem from './Dropdown/NotificationItem'
import { Link } from 'react-router-dom'

const NotificationMenu = ({notifications=[]}) => {
  const renderNotification = (n) => (
      <NotificationItem key={n.id} {...n} />
  )

  return (
      <DropdownLink icon='notifications' count={notifications.length}>
        <div className='dropdown-menu wide'>
          <ul className='scroll'>
            {notifications.map(renderNotification)}
            {notifications.length > 0 || <li className='empty-item'>No new notifications.</li>}
          </ul>
          <Link to='/notifications' className='cap-link'>See More...</Link>
        </div>
      </DropdownLink>
  )
}

NotificationMenu.propTypes = {
  notifications: PropTypes.array.isRequired
}

export default NotificationMenu
