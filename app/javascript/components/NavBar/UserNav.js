import React from 'react'
import PropTypes from 'prop-types'
import UserMenu from './UserMenu'
import CartMenu from './CartMenu'
import TransferMenu from './TransferMenu'
import NotificationMenu from './NotificationMenu'
import ConversationMenu from './ConversationMenu'
import Restrict from "../Shared/Restrict";

const UserNav = (props) => (
  <ul className='right'>
    <CartMenu />
    <TransferMenu />
    <Restrict patron>
      <ConversationMenu />
      <NotificationMenu />
    </Restrict>
    <UserMenu {...props} />
  </ul>
)

UserNav.propTypes = {
  user: PropTypes.shape({
    avatar_url: PropTypes.string.isRequired
  }).isRequired,
  nsfwOk: PropTypes.bool,
  onNsfwClick: PropTypes.func.isRequired,
  onLogoutClick: PropTypes.func.isRequired
}

export default UserNav
