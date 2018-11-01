import React, { Component } from 'react'
import PropTypes from 'prop-types'
import UserMenu from './UserMenu'
import DropdownLink from './DropdownLink'
import { NavLink } from 'react-router-dom'
import NotificationMenu from './NotificationMenu'
import MessageMenu from './MessageMenu'

class UserNav extends Component {
  constructor (props) {
    super(props)
  }

  render () {
    const notifications = [1,2,3,4,5,6,7,8,9,0].map(id=>({id}))

    return (
        <ul className='right'>
          <MessageMenu />
          <NotificationMenu notifications={notifications}/>
          <UserMenu {...this.props} />
        </ul>
    )
  }
}

UserNav.propTypes = {
  user: PropTypes.shape({
    avatar_url: PropTypes.string.isRequired
  }).isRequired,
  nsfwOk: PropTypes.bool,
  onNsfwClick: PropTypes.func.isRequired,
  onLogoutClick: PropTypes.func.isRequired
}

export default UserNav
