/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Views.User.Follow = React.createClass({
  contextTypes: {
    currentUser: React.PropTypes.object,
  },

  propTypes: {
    username: React.PropTypes.string.isRequired,
    followed: React.PropTypes.bool,
    onFollow: React.PropTypes.func,
    short: React.PropTypes.bool,
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
      this.context.currentUser &&
      this.props.username !== this.context.currentUser.username
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
