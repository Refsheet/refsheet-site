import React from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
// import subscription from './subscription'

const CartMenu = ({
  cart = [],
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
    } else if (cart.length > 0) {
      return cart.map(renderNotification)
    } else {
      return <li className="empty-item">No new cart.</li>
    }
  }

  const unreadCount = cart.filter(n => n.is_unread).length

  if (!unreadCount) {
    return null
  }

  const tryRefetch = () => {
    if (refetch) refetch()
  }

  return (
    <DropdownLink icon="shopping_cart" count={unreadCount} onOpen={tryRefetch}>
      <div className="dropdown-menu wide">
        <div className="title">
          <div className="right">
            <a href={'#'}>Accept All</a>
          </div>
          <strong>Shopping Cart</strong>
        </div>
        <Scrollbars>
          <ul>{renderContent()}</ul>
        </Scrollbars>
        <Link to="/cart" className="cap-link">
          See More...
        </Link>
      </div>
    </DropdownLink>
  )
}

CartMenu.propTypes = {
  cart: PropTypes.array,
}

export { CartMenu }
export default CartMenu
