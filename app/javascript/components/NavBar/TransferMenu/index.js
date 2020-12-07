import React from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
// import subscription from './subscription'

const TransferMenu = ({
  transfers = [],
  loading = false,
  error,
  subscribe,
  refetch,
}) => {
  const renderNotification = n => <NotificationItem key={n.id} {...n} />

  if (!loading && !error) if (subscribe) subscribe()

  const renderContent = () => {
    if (loading) {
      return <li className="empty-item">Loading...</li>
    } else if (error) {
      return <li className="empty-item red-text">{error}</li>
    } else if (transfers.length > 0) {
      return transfers.map(renderNotification)
    } else {
      return <li className="empty-item">No new transfers.</li>
    }
  }

  const unreadCount = transfers.filter(n => n.is_unread).length

  if (!unreadCount) {
    return null
  }

  const tryRefetch = () => {
    if (refetch) refetch()
  }

  return (
    <DropdownLink icon="swap_horiz" count={unreadCount} onOpen={tryRefetch}>
      <div className="dropdown-menu wide">
        <div className="title">
          <div className="right">
            <a href={'#'}>Accept All</a>
          </div>
          <strong>Transfers</strong>
        </div>
        <Scrollbars>
          <ul>{renderContent()}</ul>
        </Scrollbars>
        <Link to="/transfers" className="cap-link">
          See More...
        </Link>
      </div>
    </DropdownLink>
  )
}

TransferMenu.propTypes = {
  transfers: PropTypes.array,
}

export { TransferMenu }
export default TransferMenu
