/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Views from 'v1/views/_views'
import { Link } from 'react-router-dom'
import Icon from '../../../shared/material/Icon'
import DateFormat from '../../../shared/utils/DateFormat'
import IdentityLink from 'v1/shared/identity_link'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

let Card
export default Card = createReactClass({
  propTypes: {
    type: PropTypes.string.isRequired,
    actionable: PropTypes.object,
    actionables: PropTypes.array,
    user: PropTypes.object.isRequired,
    character: PropTypes.object,
    timestamp: PropTypes.number.isRequired,
    onReadChange: PropTypes.func.isRequired,
  },

  getInitialState() {
    return { is_read: this.props.is_read }
  },

  _getIdentity() {
    if (this.props.character) {
      return {
        avatarUrl: this.props.character.profile_image_url,
        name: this.props.character.name,
        link: this.props.character.link,
        is_admin: this.props.user.is_admin,
        is_patron: this.props.user.is_patron,
        username: this.props.user.username,
        type: 'character',
      }
    } else {
      return {
        avatarUrl: this.props.user.avatar_url,
        name: this.props.user.name,
        link: this.props.user.link,
        username: this.props.user.username,
        is_admin: this.props.user.is_admin,
        is_patron: this.props.user.is_patron,
        type: 'user',
      }
    }
  },

  _getActionables(key) {
    let out = this.props.actionables || [this.props.actionable]
    if (typeof key !== 'undefined') {
      out = out.map(out => out[key])
    }
    return out
  },

  _getActionable() {
    if (!this.props.actionable) {
      return null
    }

    switch (this.props.type) {
      case 'Notifications::ImageFavorite':
        return (
          <Views.Account.Activities.Image
            images={this._getActionables('media')}
            action="Likes"
          />
        )

      case 'Notifications::ImageComment':
        return (
          <Views.Account.Activities.Comment comments={this._getActionables()} />
        )

      case 'Notifications::ForumReply':
        return (
          <Views.Account.Activities.ForumPost posts={this._getActionables()} />
        )

      case 'Notifications::ForumTag':
        return (
          <Views.Account.Activities.ForumPost
            action="Mentioned you in"
            posts={this._getActionables()}
          />
        )

      default:
        return (
          <div className="red-text padding-bottom--medium">
            {this.props.title} (Unsupported notification card)
            <br />
            <Link to={this.props.href}>{this.props.message}</Link>
          </div>
        )
    }
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.is_read !== this.state.is_read) {
      return this.setState({ is_read: newProps.is_read })
    }
  },

  render() {
    let imgShadow, nameColor, unreadLink
    const identity = this._getIdentity()

    if (identity.is_admin) {
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'
    } else if (identity.is_patron) {
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'
    }

    const classNames = [
      'card sp with-avatar margin-bottom--medium notification',
    ]

    if (this.state.is_read) {
      unreadLink = (
        <a
          href="#"
          onClick={this.props.onReadChange(false, this.props.path)}
          className="right action-link done"
          data-tooltip="Mark Unread"
          title="Mark Unread"
        >
          <Icon>drafts</Icon>
        </a>
      )
    } else {
      unreadLink = (
        <a
          href="#"
          onClick={this.props.onReadChange(true, this.props.path)}
          className="right action-link"
          data-tooltip="Mark Read"
          title="Mark Read"
        >
          <Icon>done</Icon>
        </a>
      )

      classNames.push('notification-unread')
    }

    return (
      <div className={classNames.join(' ')}>
        <img
          className="avatar circle"
          src={identity.avatarUrl}
          alt={identity.name}
          style={{ boxShadow: imgShadow }}
        />

        <div className="card-content padding-bottom--none">
          <div className="muted right">
            <DateFormat timestamp={this.props.timestamp} fuzzy />
            {unreadLink}
          </div>
          <IdentityLink to={identity} />

          {this._getActionable()}
        </div>

        <div className="clearfix" />
      </div>
    )
  },
})
