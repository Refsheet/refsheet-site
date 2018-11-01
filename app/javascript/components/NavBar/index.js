import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import SearchBar from './SearchBar'
import SiteNav from './SiteNav'
import UserNav from './UserNav'
import SessionNav from './SessionNav'
import { connect } from 'react-redux'

import {
  setCurrentUser,
  setNsfwMode
} from 'actions'

class NavBar extends Component {
  constructor(props) {
    super(props)

    this.state = {
      sessionModalOpen: false,
      register: false,
      menuOpen: false
    }

    this.handleLoginClick = this.handleLoginClick.bind(this)
    this.handleLogoutClick = this.handleLogoutClick.bind(this)
    this.handleNsfwClick = this.handleNsfwClick.bind(this)
    this.handleMenuClose = this.handleMenuClose.bind(this)
    this.handleMenuToggle = this.handleMenuToggle.bind(this)
  }

  handleLoginClick(e) {
    e.preventDefault()
    console.log("Login")
    this.setState({
      sessionModalOpen: true,
      register: false
    })
  }

  handleRegisterClick(e) {
    e.preventDefault()
    console.log("Register")
    this.setState({
      sessionModalOpen: true,
      register: true
    })
  }

  handleLogoutClick(e) {
    e.preventDefault()
    this.props.setCurrentUser(null)
  }

  handleNsfwClick(e) {
    e.preventDefault()
    console.log("NSFW")
  }

  handleMenuToggle(e) {
    e.preventDefault()
    this.setState({menuOpen: !this.state.menuOpen})
  }

  handleMenuClose(e) {
    e.preventDefault()
    this.setState({menuOpen: false})
  }

  render() {
    const {
      query,
      session: {
        nsfw_ok: nsfwOk,
        current_user: user
      }
    } = this.props

    return (
        <div className='NavBar navbar-fixed user-bar'>
          <div className='navbar-shroud' onClick={ this.handleMenuClose } />

          <nav>
            <div className='container'>
              <ul className='menu left hide-on-med-and-up'>
                <li><a onClick={ this.handleMenuToggle }><i className='material-icons'>menu</i></a></li>
              </ul>

              <Link to='/' className='logo left'>
                <img src='/assets/logos/pumpkin2_64.png' alt='Refsheet.net' width='32' height='32' />
              </Link>

              <SiteNav />

              <div className='right'>
                <SearchBar query={ query } />

                { user
                  ? <UserNav
                        onNsfwClick={this.handleNsfwClick}
                        onLogoutClick={this.handleLogoutClick}
                        nsfwOk={nsfwOk}
                        user={user}
                    />
                  : <SessionNav
                        onNsfwClick={this.handleNsfwClick}
                        onLoginClick={this.handleLoginClick}
                        nsfwOk={nsfwOk}
                    /> }
              </div>
            </div>
          </nav>
        </div>
    )
  }
}

NavBar.propTypes = {
  query: PropTypes.string,
  session: PropTypes.shape({
    current_user: PropTypes.object,
    nsfw_ok: PropTypes.bool
  }),
  setCurrentUser: PropTypes.func
}

const mapStateToProps = ({session}, props) => ({
  session,
  ...props
})

const mapDispatchToProps = {
  setCurrentUser,
  setNsfwMode
}

export default connect(mapStateToProps, mapDispatchToProps)(NavBar)
