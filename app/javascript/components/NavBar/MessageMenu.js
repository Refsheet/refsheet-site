import React from 'react'
import PropTypes from 'prop-types'
import { NavLink } from 'react-router-dom'

const MessageMenu = ({}) => {
  return (
      <li>
        <NavLink to='/messages' activeClassName='primary-text'>
          <i className='material-icons'>message</i>
          <span className='count'>12k</span>
        </NavLink>
      </li>
  )
}

MessageMenu.propTypes = {}

export default MessageMenu
