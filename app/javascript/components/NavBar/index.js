import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import SearchBar from './SearchBar'
import SiteNav from './SiteNav'

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

          <SiteNav />

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
