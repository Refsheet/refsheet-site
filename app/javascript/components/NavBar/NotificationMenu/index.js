import React from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'

const NotificationMenu = ({notifications=[], unreadCount, loading=false, error, subscribe, refetch}) => {
  const renderNotification = (n) => (
      <NotificationItem key={n.id} {...n} />
  )

  if (!loading && !error)
    subscribe()

  const renderContent = () => {
    if(loading) {
      return <li className='empty-item'>Loading...</li>
    } else if(error) {
      return <li className='empty-item red-text'>{ error }</li>
    } else if(notifications.length > 0) {
      return notifications.map(renderNotification)
    } else {
      return <li className='empty-item'>No new notifications.</li>
    }
  }

  const tryRefetch = () => {
    if(refetch) refetch()
  }

  return (
      <DropdownLink icon='notifications' count={unreadCount} onOpen={tryRefetch}>
        <div className='dropdown-menu wide'>
          <div className='title'>
            <div className='right'>
              <a href={'#'}>Mark All Read</a>
            </div>
            <strong>Notifications</strong>
          </div>
          <Scrollbars>
            <ul>
              {renderContent()}
            </ul>
          </Scrollbars>
          <Link to='/notifications' className='cap-link'>See More...</Link>
        </div>
      </DropdownLink>
  )
}

NotificationMenu.propTypes = {
  notifications: PropTypes.array,
  unreadCount: PropTypes.number
}

export { NotificationMenu }

export default subscription(NotificationMenu)
