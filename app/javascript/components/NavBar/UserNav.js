import React, { Component } from 'react'
import PropTypes from 'prop-types'
import UserMenu from './UserMenu'
import DropdownLink from './DropdownLink'
import { NavLink } from 'react-router-dom'

class UserNav extends Component {
  constructor (props) {
    super(props)
  }

  render () {
    const {
      user,
      nsfwOk
    } = this.props

    const nsfwClassName = nsfwOk ? 'nsfw' : 'no-nsfw'

    return (
        <ul className='right'>
          <li>
            <NavLink to='/messages' activeClassName='primary-text'>
              <i className='material-icons'>message</i>
            </NavLink>
          </li>

          <DropdownLink icon='notifications' count={1}>
          </DropdownLink>

          <DropdownLink imageSrc={ user.avatar_url } className={nsfwClassName}>
            <UserMenu {...this.props} />
          </DropdownLink>
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
