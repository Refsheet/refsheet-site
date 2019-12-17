import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import SearchBar from './SearchBar'
import SiteNav from './SiteNav'
import UserNav from './UserNav'
import SessionNav from './SessionNav'
import { connect } from 'react-redux'

import { setCurrentUser, setNsfwMode } from 'actions'
import SessionService from '../../services/SessionService'
import IdentityModal from '../Shared/CommentForm/IdentityModal'

class NavBar extends Component {
  constructor(props) {
    super(props)

    this.state = {
      sessionModalOpen: false,
      identityModalOpen: false,
      register: false,
      noticeClosed: false,
      menuOpen: false,
    }

    this.handleLoginClick = this.handleLoginClick.bind(this)
    this.handleLogoutClick = this.handleLogoutClick.bind(this)
    this.handleNsfwClick = this.handleNsfwClick.bind(this)
    this.handleMenuClose = this.handleMenuClose.bind(this)
    this.handleMenuToggle = this.handleMenuToggle.bind(this)
  }

  handleLoginClick(e) {
    e.preventDefault()
    this.setState({
      sessionModalOpen: true,
      register: false,
    })
  }

  handleRegisterClick(e) {
    e.preventDefault()
    this.setState({
      sessionModalOpen: true,
      register: true,
    })
  }

  handleLogoutClick(e) {
    e.preventDefault()
    SessionService.logout().then(() => {
      this.props.setCurrentUser(null)
    })
  }

  handleNsfwClick(e) {
    e.preventDefault()
    const { nsfwOk } = this.props.session
    this.props.setNsfwMode(!nsfwOk)
  }

  handleMenuToggle(e) {
    e.preventDefault()
    this.setState({ menuOpen: !this.state.menuOpen })
  }

  handleMenuClose(e) {
    e.preventDefault()
    this.setState({ menuOpen: false })
  }

  handleNoticeClose(e) {
    e.preventDefault()
    this.setState({ noticeClosed: true })
  }

  handleIdentityOpen(e) {
    e.preventDefault()
    this.setState({ identityModalOpen: true })
  }

  handleIdentityClose() {
    this.setState({ identityModalOpen: false })
  }

  render() {
    const {
      query,
      session: { nsfwOk, currentUser, identity },
    } = this.props

    return (
      <div className="NavBar navbar-fixed user-bar">
        <div className="navbar-shroud" onClick={this.handleMenuClose} />

        {!this.state.noticeClosed && this.props.notice && (
          <div
            className={'navbar-notice'}
            onClick={this.handleNoticeClose.bind(this)}
          >
            <div className={'container'}>
              <strong>Notice:</strong> {this.props.notice}
            </div>

            <button
              type={'button'}
              className={'notice-close'}
              onClick={this.handleNoticeClose.bind(this)}
            >
              <i className={'material-icons'}>close</i>
            </button>
          </div>
        )}

        {this.state.identityModalOpen && (
          <IdentityModal onClose={this.handleIdentityClose.bind(this)} />
        )}

        <nav>
          <div className="container">
            <ul className="menu left hide-on-med-and-up">
              <li>
                <a onClick={this.handleMenuToggle}>
                  <i className="material-icons">menu</i>
                </a>
              </li>
            </ul>

            <Link to="/" className="logo left">
              <img
                src="/assets/logos/pumpkin2_64.png"
                alt="Refsheet.net"
                width="32"
                height="32"
              />
            </Link>

            <SiteNav />

            <div className="right">
              <SearchBar query={query} />

              {currentUser ? (
                <UserNav
                  onNsfwClick={this.handleNsfwClick}
                  onLogoutClick={this.handleLogoutClick}
                  nsfwOk={nsfwOk}
                  user={currentUser}
                  identity={identity}
                  onIdentityClick={this.handleIdentityOpen.bind(this)}
                />
              ) : (
                <SessionNav
                  onNsfwClick={this.handleNsfwClick}
                  onLoginClick={this.handleLoginClick}
                  nsfwOk={nsfwOk}
                />
              )}
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
    currentUser: PropTypes.object,
    nsfwOk: PropTypes.bool,
  }),
  setCurrentUser: PropTypes.func,
  setNsfwMode: PropTypes.func,
  notice: PropTypes.string,
}

const mapStateToProps = ({ session }, props) => ({
  session,
  ...props,
})

const mapDispatchToProps = {
  setCurrentUser,
  setNsfwMode,
}

const options = {
  pure: false,
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  null,
  options
)(NavBar)
