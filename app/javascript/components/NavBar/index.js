import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { NavLink, Link } from 'react-router-dom'
import SearchBar from './SearchBar'

class NavBar extends Component {
  render() {
    const currentUser = null

    return (<div className='navbar-fixed user-bar'>
      <div className='navbar-shroud' onClick={ this.closeMenu } />

      <nav>
        <div className='container'>
          <ul className='menu left hide-on-med-and-up'>
            <li><a onClick={ this.toggleMenu }><i className='material-icons'>menu</i></a></li>
          </ul>

          <Link to='/' className='logo left'>
            <img src='/assets/logos/pumpkin2_64.png' alt='Refsheet.net' width='32' height='32' />
          </Link>

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

          <div className='right'>
            <SearchBar query={ this.props.query } />

            { currentUser }
          </div>
        </div>
      </nav>
    </div>)
  }
}

NavBar.propTypes = {
  query: PropTypes.string
}

export default NavBar
