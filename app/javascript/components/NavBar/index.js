import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import SearchBar from './SearchBar'
import SiteNav from './SiteNav'
import UserNav from './UserNav'

class NavBar extends Component {
  render() {
    const {
      query,
      session: {
        nsfw_ok: nsfwOk,
        current_user: user
      }
    } = this.props

    return (<div className='NavBar navbar-fixed user-bar'>
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
            <SearchBar query={ query } />

            <UserNav nsfwOk={nsfwOk} user={user} />
          </div>
        </div>
      </nav>
    </div>)
  }
}

NavBar.propTypes = {
  query: PropTypes.string,
  session: PropTypes.shape({
    current_user: PropTypes.object,
    nsfw_ok: PropTypes.bool
  }),
  onUserChange: PropTypes.func
}

export default NavBar
