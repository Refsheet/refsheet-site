/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'
import Icon from '../../shared/material/Icon'
import RichText from '../../../components/Shared/RichText'
import $ from 'jquery'
import Model from '../../utils/Model'
import * as UserUtils from '../../../utils/UserUtils'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Header = createReactClass({
  contextTypes: {
    currentUser: PropTypes.object,
  },

  propTypes: {
    onFollow: PropTypes.func.isRequired,
  },

  handleBioChange(data) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: this.props.path,
        type: 'PATCH',
        data: { user: { profile: data.value } },
        success: user => {
          this.props.onUserChange(user)
          return resolve({ value: user.profile_markup })
        },
        error: reject,
      })
    })
  },

  _handleFollowClick(e) {
    const action = this.props.followed ? 'delete' : 'post'
    Model.request(
      action,
      '/users/' + this.props.username + '/follow.json',
      {},
      user => {
        return this.props.onFollow(user.followed)
      }
    )
    return e.preventDefault()
  },

  render() {
    let bioChangeCallback, canFollow, editable, followColor, imageStyle
    if (this.props.onUserChange != null) {
      bioChangeCallback = this.handleBioChange
      const followCallback = this.props.onFollow
      editable = true
    }

    if (
      this.context.currentUser &&
      this.props.username !== this.context.currentUser.username
    ) {
      canFollow = true
      followColor = this.props.followed ? '#ffca28' : 'rgba(255, 255, 255, 0.7)'
    }

    const userColor = UserUtils.userFgColor(this.props)
    const userBgColor = UserUtils.userBgColor(this.props)

    if (userColor) {
      imageStyle = { boxShadow: `${userColor} 0px 0px 3px 1px` }
    }

    return (
      <div className="user-header" style={{ backgroundColor: userBgColor }}>
        <div className="container flex">
          <div className="user-avatar">
            <div className="image" style={imageStyle}>
              {editable && (
                <div className="image-edit-overlay">
                  <div className="content">
                    <i className="material-icons">photo_camera</i>
                    Change Avatar
                  </div>
                </div>
              )}

              <img
                src={this.props.profile_image_url}
                alt={this.props.username}
              />
            </div>
          </div>
          <div className="user-data">
            <div className="avatar-shift">
              {canFollow && (
                <a
                  href="#"
                  className="secondary-content btn btn-flat right"
                  style={{ border: '1px solid rgba(255,255,255,0.1)' }}
                  onClick={this._handleFollowClick}
                >
                  <span className="hide-on-med-and-down">
                    {this.props.followed ? 'Following' : 'Follow'}
                  </span>
                  <Icon style={{ color: followColor }} className="right">
                    person_add
                  </Icon>
                </a>
              )}

              <h1 className="name" style={{ color: userColor }}>
                {this.props.name}
              </h1>
              <div className="username">
                @{this.props.username}
                {this.props.is_admin && (
                  <span
                    className="user-badge admin-badge"
                    title="Site administrator"
                  >
                    <i
                      className="material-icons"
                      style={{ color: UserUtils.USER_FG_COLOR.admin }}
                    >
                      security
                    </i>
                  </span>
                )}
                {this.props.is_patron && (
                  <span className="user-badge patron-badge" title="Site Patron">
                    <img
                      src="/assets/third_party/patreon_logo.png"
                      alt="Patreon"
                    />
                  </span>
                )}
                {this.props.is_supporter && (
                  <span
                    className="user-badge supporter-badge"
                    title="Site Supporter"
                  >
                    <i
                      className="material-icons"
                      style={{ color: UserUtils.USER_FG_COLOR.supporter }}
                    >
                      star
                    </i>
                  </span>
                )}
              </div>
            </div>
            <div className="user-bio">
              <RichText
                contentHtml={this.props.profile}
                content={this.props.profile_markup}
                onChange={bioChangeCallback}
                title={'About ' + this.props.name}
                titleComponent={'p'}
              />
            </div>
          </div>
        </div>
      </div>
    )
  },
})

export default Header
