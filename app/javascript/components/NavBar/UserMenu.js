import React from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import DropdownLink from './DropdownLink'

const UserMenu = ({user, nsfwOk, onNsfwClick, onLogoutClick}) => {
  const nsfwClassName = nsfwOk ? 'nsfw' : 'no-nsfw'

  return (
      <DropdownLink imageSrc={ user.avatar_url } className={nsfwClassName}>
        <ul className='dropdown-menu'>
          <li>
            <Link to={'/' + user.username}>
              <i className='material-icons left'>person</i>
              <span>{ user.name }</span><br />
              <span className='muted'>@{ user.username }</span>
            </Link>
          </li>

          { user.is_admin &&
          <li>
            <a href='/admin'>
              <i className='material-icons left'>vpn_key</i>
              <span>Admin</span>
            </a>
          </li>
          }

          <li className='divider' />

          <li>
            <a onClick={ onNsfwClick } className={ nsfwClassName }>
              <i className='material-icons left'>{ nsfwOk ? 'remove_circle' : 'remove_circle_outline' }</i>
              <span>{ nsfwOk ? 'Hide NSFW' : 'Show NSFW' }</span>
            </a>
          </li>

          <li>
            <a onClick={ onLogoutClick }>
              <i className='material-icons left'>exit_to_app</i>
              <span>Sign Out</span>
            </a>
          </li>
        </ul>
      </DropdownLink>
  )
}

UserMenu.propTypes = {
  nsfwOk: PropTypes.bool,
  user: PropTypes.shape({
    username: PropTypes.string.isRequired,
    is_admin: PropTypes.bool
  }),
  onNsfwClick: PropTypes.func.isRequired,
  onLogoutClick: PropTypes.func.isRequired
}

export default UserMenu
