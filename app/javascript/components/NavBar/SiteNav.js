import React from 'react'
import PropTypes from 'prop-types'
import { NavLink } from 'react-router-dom'

const SiteNav = ({}) => {
  return (
      <ul className='site-nav visible-on-med-and-up'>
        <li>
          <NavLink to='/' exact activeClassName='primary-text'>Home</NavLink>
        </li>

        <li>
          <NavLink to='/browse' activeClassName='primary-text'>Characters</NavLink>
        </li>

        <li>
          <NavLink to='/explore' activeClassName='primary-text'>Images</NavLink>
        </li>

        <li>
          <NavLink to='/forums' activeClassName='primary-text'>Forums</NavLink>
        </li>

        {/*<li>*/}
        {/*<NavLink to='/guilds' activeClassName='primary-text'>Guilds</NavLink>*/}
        {/*</li>*/}

        {/*<li>*/}
        {/*<NavLink to='/marketplace'>Marketplace</NavLink>*/}
        {/*</li>*/}
      </ul>
  )
}

SiteNav.propTypes = {}

export default SiteNav
