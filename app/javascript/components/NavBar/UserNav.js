import React from 'react'
import PropTypes from 'prop-types'
import UserMenu from './UserMenu'
import NotificationMenu from './NotificationMenu'
import ConversationMenu from './ConversationMenu'

const UserNav = (props) => (
  <ul className='right'>
    <ConversationMenu />
    <NotificationMenu />
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
