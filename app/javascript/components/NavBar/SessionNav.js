import React from 'react'
import PropTypes from 'prop-types'
import DropdownLink from './DropdownLink'

const SessionNav = ({nsfwOk}) => {
  const nsfwClassName = nsfwOk ? 'nsfw' : 'no-nsfw'

  return (
      <ul className='right'>
        <DropdownLink icon='person' text='Sign In'>
          <ul className='dropdown-menu'>
            <li>
              <a href='#session-modal' className='modal-trigger'>
                <i className='material-icons left'>person</i>
                <span>Sign In</span>
              </a>
            </li>
            <li>
              <Link to='/register'>
                <i className='material-icons left'>create</i>
                <span>Register</span>
              </Link>
            </li>

            <li className='divider' />

            <li>
              <a onClick={ this._handleNsfwToggle } className={ nsfwClassName }>
                <i className='material-icons left'>{ nsfwOk ? 'remove_circle' : 'remove_circle_outline' }</i>
                <span>{ nsfwOk ? 'Hide NSFW' : 'Show NSFW' }</span>
              </a>
            </li>
          </ul>
        </DropdownLink>
      </ul>
  )
}

SessionNav.propTypes = {
  nsfwOk: PropTypes.bool
}

export default SessionNav
