import React from 'react'
import PropTypes from 'prop-types'

const UserMenu = ({user, nsfwOk}) => {
  const nsfwClassName = nsfwOk ? 'nsfw' : 'no-nsfw'

  return (
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
          <a onClick={ this._handleNsfwToggle } className={ nsfwClassName }>
            <i className='material-icons left'>{ nsfwOk ? 'remove_circle' : 'remove_circle_outline' }</i>
            <span>{ nsfwOk ? 'Hide NSFW' : 'Show NSFW' }</span>
          </a>
        </li>

        <li>
          <a onClick={ this._handleSignOut }>
            <i className='material-icons left'>exit_to_app</i>
            <span>Sign Out</span>
          </a>
        </li>
      </ul>
  )
}

UserMenu.propTypes = {
  nsfwOk: PropTypes.bool,
  user: PropTypes.shape({
    username: PropTypes.string.isRequired,
    is_admin: PropTypes.bool
  })
}

export default UserMenu
