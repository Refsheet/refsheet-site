import React from 'react'
import PropTypes from 'prop-types'
import UserMenu from './UserMenu'
import CartMenu from './CartMenu'
import TransferMenu from './TransferMenu'
import NotificationMenu from './NotificationMenu'
import ConversationMenu from './ConversationMenu'
import UploadMenu from './UploadMenu'
import Restrict from '../Shared/Restrict'
import compose from '../../utils/compose'

const UserNav = props => (
  <ul className="right">
    <CartMenu />
    <TransferMenu />
    <UploadMenu />
    <ConversationMenu />
    <NotificationMenu />
    <UserMenu {...props} />
  </ul>
)

UserNav.propTypes = {
  user: PropTypes.shape({
    avatar_url: PropTypes.string.isRequired,
  }).isRequired,
  nsfwOk: PropTypes.bool,
  onNsfwClick: PropTypes.func.isRequired,
  onLogoutClick: PropTypes.func.isRequired,
}

export default compose()(UserNav)
