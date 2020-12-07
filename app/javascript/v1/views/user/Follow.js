/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Icon from '../../shared/material/Icon'
import Model from '../../utils/Model'
import compose, { withCurrentUser } from '../../../utils/compose'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Follow = createReactClass({
  propTypes: {
    username: PropTypes.string.isRequired,
    followed: PropTypes.bool,
    onFollow: PropTypes.func,
    short: PropTypes.bool,
  },

  _handleFollowClick(e) {
    const action = this.props.followed ? 'delete' : 'post'
    Model.request(
      action,
      '/users/' + this.props.username + '/follow.json',
      {},
      user => {
        if (this.props.onFollow) {
          return this.props.onFollow(user.followed, this.props.username, user)
        }
      }
    )
    return e.preventDefault()
  },

  render() {
    if (
      this.props.currentUser &&
      this.props.username !== this.props.currentUser.username
    ) {
      const followColor = this.props.followed
        ? '#ffca28'
        : 'rgba(255, 255, 255, 0.7)'

      return (
        <a
          href="#"
          className="secondary-content btn btn-flat right cs--secondary-color"
          style={{ border: '1px solid rgba(255,255,255,0.1)' }}
          onClick={this._handleFollowClick}
        >
          {!this.props.short && (
            <span
              className="hide-on-med-and-down cs--secondary-color"
              style={{ marginRight: '1rem' }}
            >
              {this.props.followed ? 'Following' : 'Follow'}
            </span>
          )}

          <Icon
            style={{ color: followColor, marginLeft: '0' }}
            className="right"
          >
            person_add
          </Icon>
        </a>
      )
    } else {
      return null
    }
  },
})

export default compose(withCurrentUser())(Follow)
