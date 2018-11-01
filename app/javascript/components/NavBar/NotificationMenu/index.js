import React from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'

const NotificationMenu = ({notifications=[], loading=false}) => {
  const renderNotification = (n) => (
      <NotificationItem key={n.id} {...n} />
  )

  return (
      <DropdownLink icon='notifications' count={notifications.length}>
        <div className='dropdown-menu wide'>
          <Scrollbars>
            <ul>
              {notifications.map(renderNotification)}
              {loading && <li className='empty-item'>Loading...</li>}
              {notifications.length > 0 || <li className='empty-item'>No new notifications.</li>}
            </ul>
          </Scrollbars>
          <Link to='/notifications' className='cap-link'>See More...</Link>
        </div>
      </DropdownLink>
  )
}

NotificationMenu.propTypes = {
  notifications: PropTypes.array
}

export { NotificationMenu }

export default subscription(NotificationMenu)
