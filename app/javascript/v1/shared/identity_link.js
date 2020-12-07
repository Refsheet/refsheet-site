import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import { Link } from 'react-router-dom'
import Icon from 'v1/shared/material/Icon'
import StringUtils from '../../utils/StringUtils'
import NumberUtils from '../utils/NumberUtils'
import $ from 'jquery'
import Model from '../utils/Model'
import compose, { withCurrentUser } from '../../utils/compose'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const IdentityLink = createReactClass({
  propTypes: {
    to: PropTypes.shape({
      link: PropTypes.string.isRequired,
      name: PropTypes.string.isRequired,
      username: PropTypes.string.isRequired,
      type: PropTypes.string,
      avatar_url: PropTypes.string,
    }),
    name: PropTypes.string,
    link: PropTypes.string,
    avatarUrl: PropTypes.string,
  },

  timer: null,

  getInitialState() {
    return { user: null }
  },

  _load() {
    return $.get('/users/' + this.props.to.username + '/follow.json', user => {
      return this.setState({ user })
    })
  },

  _handleFollowClick(e) {
    const action = this.state.user.followed ? 'delete' : 'post'
    Model.request(
      action,
      '/users/' + this.props.to.username + '/follow.json',
      {},
      user => {
        return this.setState({ user })
      }
    )
    return e.preventDefault()
  },

  _handleLinkMouseover() {
    return (this.timer = setTimeout(() => {
      $(this.refs.info).fadeIn()
      return this._load()
    }, 750))
  },

  _handleLinkMouseout() {
    return clearTimeout(this.timer)
  },

  _handleCardMouseover() {
    return clearTimeout(this.timer)
  },

  _handleCardMouseout(e) {
    return (this.timer = setTimeout(() => {
      return $(this.refs.info).fadeOut()
    }, 250))
  },

  render() {
    let byline,
      canFollow,
      followColor,
      followed,
      follower,
      imgShadow,
      isYou,
      mutual,
      nameColor
    const { user } = this.state
    const to = StringUtils.indifferentKeys(this.props.to)

    if (this.props.avatarUrl) {
      if (!to.type) {
        to.type = 'character'
      }
    } else {
      if (!to.type) {
        to.type = 'user'
      }
    }

    if (to.is_admin || (user != null ? user.is_admin : undefined)) {
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'
    } else if (to.is_patron || (user != null ? user.is_patron : undefined)) {
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'
    }

    if (user) {
      ;({ followed, follower } = user)

      mutual = followed || follower
      followColor = followed ? '#ffca28' : 'rgba(255, 255, 255, 0.7)'
      isYou =
        to.username ===
        (this.props.currentUser != null
          ? this.props.currentUser.username
          : undefined)
      canFollow = !!this.props.currentUser && !isYou

      if (to.type === 'character') {
        byline = (
          <div
            className="byline"
            style={{
              lineHeight: '1rem',
              marginBottom: '2px',
              marginTop: '3px',
            }}
          >
            By: <Link to={'/' + to.username}>{user.name}</Link>
          </div>
        )
      }
    }

    return (
      <div
        className="identity-link-wrapper"
        style={{ position: 'relative', display: 'inline-block' }}
      >
        <div
          className="identity-card card with-avatar z-depth-2 sp"
          ref="info"
          onMouseOut={this._handleCardMouseout}
          onMouseOver={this._handleCardMouseover}
          style={{
            position: 'absolute',
            top: '0rem',
            marginTop: '-1rem',
            left: 'calc(-48px - 2rem)',
            zIndex: '899',
            minWidth: '300px',
            backgroundColor: 'rgba(26, 26, 26, 1)',
            display: 'none',
          }}
        >
          {(to.avatarUrl || this.props.avatarUrl) && (
            <img
              src={this.props.avatarUrl || to.avatarUrl}
              alt={this.props.name || to.name}
              className="avatar circle"
              style={{ boxShadow: imgShadow }}
              height={48}
              width={48}
            />
          )}

          <div className="card-content">
            {canFollow && (
              <a
                href="#"
                className="secondary-content right"
                style={{ color: followColor, display: 'block' }}
                onClick={this._handleFollowClick}
              >
                <Icon>person_add</Icon>
              </a>
            )}

            <Link
              to={this.props.link || to.link}
              style={{
                display: 'block',
                whiteSpace: 'nowrap',
                marginRight: '3rem',
                color: nameColor,
              }}
            >
              {this.props.name || to.name}
            </Link>

            <div
              className="smaller"
              style={{ lineHeight: '1rem', verticalAlign: 'middle' }}
            >
              {byline}

              <span style={{ color: 'rgba(255,255,255,0.6)' }}>
                @{to.username}
              </span>

              {mutual && (
                <span
                  className="followback"
                  style={{
                    fontSize: '0.6rem',
                    lineHeight: '1rem',
                    verticalAlign: 'middle',
                    padding: '0 5px',
                    borderRadius: '3px',
                    backgroundColor: 'rgba(255,255,255, 0.05)',
                    marginLeft: '0.5rem',
                    color: 'rgba(255,255,255,0.6)',
                    textTransform: 'uppercase',
                    display: 'inline-block',
                  }}
                >
                  {follower
                    ? 'Follows ' + (followed ? 'Back' : 'You')
                    : 'Following'}
                </span>
              )}

              {isYou && (
                <span
                  className="followback"
                  style={{
                    fontSize: '0.6rem',
                    lineHeight: '1rem',
                    verticalAlign: 'middle',
                    padding: '0 5px',
                    borderRadius: '3px',
                    backgroundColor: 'rgba(255,255,255, 0.05)',
                    marginLeft: '0.5rem',
                    color: 'rgba(255,255,255,0.6)',
                    textTransform: 'uppercase',
                    display: 'inline-block',
                  }}
                >
                  That's you!
                </span>
              )}
            </div>

            {user && (
              <ul className="stats stats-compact margin-bottom--none margin-top--medium">
                <li>
                  <div className="value">
                    {NumberUtils.format(user.followers)}
                  </div>
                  <div className="label">Followers</div>
                </li>
                <li>
                  <div className="value">
                    {NumberUtils.format(user.following)}
                  </div>
                  <div className="label">Following</div>
                </li>
              </ul>
            )}

            {!user && <div className="grey-text">Loading...</div>}
          </div>
        </div>

        <Link
          to={this.props.link || to.link}
          onMouseOver={this._handleLinkMouseover}
          onMouseOut={this._handleLinkMouseout}
          style={{ color: nameColor }}
        >
          {this.props.name || to.name}
        </Link>
      </div>
    )
  },
})

export default compose(withCurrentUser())(IdentityLink)
