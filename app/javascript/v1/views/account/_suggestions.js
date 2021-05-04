/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import StateUtils from '../../utils/StateUtils'
import HashUtils from '../../utils/HashUtils'
import UserCard from 'components/User/UserCard'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Suggestions
export default Suggestions = createReactClass({
  getInitialState() {
    return { suggested: null }
  },

  dataPath: '/users/suggested',

  componentDidMount() {
    return StateUtils.load(this, 'suggested', undefined, undefined, {
      urlParams: { limit: 6 },
    })
  },

  _handleFollow(f, id) {
    return HashUtils.findItem(this.state.suggested, id, function (u) {
      u.followed = f
      return StateUtils.updateItem(this, 'suggested', u)
    })
  },

  render() {
    return null

    // TODO: Suggestions are now disabled. Dunno what else to put here.

    const _this = this
    if (!this.state.suggested) {
      return null
    }

    const suggestions = this.state.suggested.map(function (user) {
      return (
        <li
          className="collection-item margin-bottom--small"
          style={{ padding: '0.5rem 0' }}
          key={user.username}
        >
          <UserCard user={user} onFollow={_this._handleFollow} smaller />
        </li>
      )
    })

    return (
      <ul
        className="collection-flat"
        style={{ marginTop: 0, marginBottom: '3rem' }}
      >
        <li
          className="subheader"
          style={{
            fontSize: '0.9rem',
            color: 'rgba(255, 255, 255, 0.3)',
            paddingBottom: '0.2rem',
            marginBottom: '0.25rem',
            borderBottom: '1px solid rgba(255, 255, 255, 0.1)',
          }}
        >
          You may like...
        </li>

        {suggestions}
      </ul>
    )
  },
})
