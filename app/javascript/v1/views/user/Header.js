import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'
import Icon from '../../shared/material/Icon'
import RichText from '../../../components/Shared/RichText'
import $ from 'jquery'
import Model from '../../utils/Model'
import * as UserUtils from '../../../utils/UserUtils'
import AvatarModal from '../../../components/User/Modals/AvatarModal'
import compose, { withCurrentUser, withMutations } from '../../../utils/compose'
import Button from '../../../components/Styled/Button'
import { Icon as MIcon } from 'react-materialize'
import { openConversation } from '../../../actions'
import { connect } from 'react-redux'
import {
  blockUser,
  unblockUser,
} from '../../../graphql/mutations/blockUser.graphql'
import Flash from '../../../utils/Flash'

const Header = createReactClass({
  propTypes: {
    onFollow: PropTypes.func.isRequired,
    blockUser: PropTypes.func,
    unblockUser: PropTypes.func,
    blocked: PropTypes.bool,
    followed: PropTypes.bool,
    user: PropTypes.shape({
      name: PropTypes.string,
      username: PropTypes.string,
      path: PropTypes.string,
      profile_image_url: PropTypes.string,
      is_admin: PropTypes.bool,
      is_patron: PropTypes.bool,
      is_supporter: PropTypes.bool,
      profile: PropTypes.string,
      profile_markup: PropTypes.string,
    }).isRequired,
    onUserChange: PropTypes.func,
    openConversation: PropTypes.func,
    currentUser: PropTypes.shape({
      username: PropTypes.string,
    }),
  },

  getInitialState(props) {
    return {
      avatarModalOpen: false,
    }
  },

  handleAvatarChange(data) {
    const user = {
      ...this.props.user,
      ...data,
    }

    this.props.onUserChange(user)
  },

  handleBioChange(data) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: this.props.user.path,
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
      '/users/' + this.props.user.username + '/follow.json',
      {},
      user => {
        return this.props.onFollow(user.followed)
      }
    )
    return e.preventDefault()
  },

  handleAvatarClick(e) {
    e.preventDefault()
    this.setState({ avatarModalOpen: true })
  },

  handleAvatarClose() {
    this.setState({ avatarModalOpen: false })
  },

  _handleBlockClick(e) {
    e.preventDefault()
    const { blocked, blockUser, unblockUser } = this.props

    Flash.info('Doing Something Important...')

    if (blocked) {
      unblockUser({
        wrapped: true,
        variables: {
          username: this.props.user.username,
        },
      }).then(({ data: { unblockUser: user } }) => {
        console.log(user)
        this.props.onFollow(user.is_followed, user.is_blocked)
      })
    } else {
      blockUser({
        wrapped: true,
        variables: {
          username: this.props.user.username,
        },
      }).then(({ data: { blockUser: user } }) => {
        console.log(user)
        this.props.onFollow(user.is_followed, user.is_blocked)
      })
    }
  },

  _handleMessageClick(e) {
    e.preventDefault()
    this.props.openConversation({ username: this.props.user.username })
  },

  render() {
    let bioChangeCallback,
      canFollow,
      editable,
      followColor,
      imageStyle,
      canMessage,
      canBlock

    if (this.props.onUserChange != null) {
      bioChangeCallback = this.handleBioChange
      editable = true
    }

    if (
      this.props.currentUser &&
      this.props.user.username !== this.props.currentUser.username
    ) {
      canFollow = !this.props.blocked
      canMessage = !this.props.blocked
      canBlock = !this.props.user.is_admin
      followColor = this.props.followed ? '#ffca28' : 'rgba(255, 255, 255, 0.7)'
    }

    const userColor = UserUtils.userFgColor(this.props)
    const userBgColor = UserUtils.userBgColor(this.props)

    if (userColor) {
      imageStyle = { boxShadow: `${userColor} 0px 0px 3px 1px` }
    }

    return (
      <div className="user-header" style={{ backgroundColor: userBgColor }}>
        {this.state.avatarModalOpen && (
          <AvatarModal
            user={this.props.currentUser}
            onSave={this.handleAvatarChange}
            onClose={this.handleAvatarClose}
          />
        )}
        <div className="container flex">
          <div className="user-avatar">
            <div className="image" style={imageStyle}>
              {editable && (
                <div
                  className="image-edit-overlay"
                  onClick={this.handleAvatarClick}
                >
                  <div className="content">
                    <i className="material-icons">photo_camera</i>
                    Change Avatar
                  </div>
                </div>
              )}

              <img
                src={this.props.user.profile_image_url}
                alt={this.props.user.username}
              />
            </div>
          </div>
          <div className="user-data">
            <div className="avatar-shift">
              <h1 className="name" style={{ color: userColor }}>
                {this.props.user.name}
              </h1>
              <div className="username">
                @{this.props.user.username}
                {this.props.user.is_admin && (
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
                {this.props.user.is_patron && (
                  <span className="user-badge patron-badge" title="Site Patron">
                    <img
                      src="/assets/third_party/patreon_logo.png"
                      alt="Patreon"
                    />
                  </span>
                )}
                {this.props.user.is_supporter && (
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
              {!this.props.blocked && (
                <RichText
                  contentHtml={this.props.user.profile}
                  content={this.props.user.profile_markup}
                  onChange={bioChangeCallback}
                  title={'About ' + this.props.user.name}
                  titleComponent={'p'}
                />
              )}
            </div>
          </div>
          <div className={'user-actions'} style={{ width: 200 }}>
            {canFollow && (
              <Button
                className="btn-muted btn-flat btn-block margin-bottom--medium"
                onClick={this._handleFollowClick}
              >
                <span className="hide-on-med-and-down">
                  {this.props.followed ? 'Following' : 'Follow'}
                </span>
                <Icon style={{ color: followColor }} className="right">
                  person_add
                </Icon>
              </Button>
            )}

            {canMessage && (
              <Button
                onClick={this._handleMessageClick}
                className={'btn-block btn-flat margin-bottom--medium'}
              >
                <MIcon right>message</MIcon>
                Message
              </Button>
            )}

            {canBlock && (
              <Button
                onClick={this._handleBlockClick}
                className={
                  'btn-block btn-flat btn-secondary margin-bottom--medium'
                }
              >
                <MIcon right>block</MIcon>
                {this.props.blocked ? 'Unblock' : 'Block'}
              </Button>
            )}
          </div>
        </div>
      </div>
    )
  },
})

const mapDispatchToProps = {
  openConversation,
}

export default compose(
  withCurrentUser(),
  connect(undefined, mapDispatchToProps),
  withMutations({ blockUser, unblockUser })
)(Header)
