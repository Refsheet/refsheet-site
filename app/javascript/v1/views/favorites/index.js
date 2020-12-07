/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Column from '../../shared/material/Column'
import Row from '../../shared/material/Row'
import Model from '../../utils/Model'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Index
export default Index = createReactClass({
  propTypes: {
    mediaId: PropTypes.string.isRequired,
    favorites: PropTypes.array,
    poll: PropTypes.bool,
    onFavoriteChange: PropTypes.func,
  },

  _poll() {
    return (this.poller = setTimeout(() => {
      return Model.poll(`/media/${this.props.mediaId}/favorites`, {}, data => {
        data.map(favorite => {
          if (this.props.onFavoriteChange) {
            return this.props.onFavoriteChange(favorite)
          }
        })
        return this._poll()
      })
    }, 15000))
  },

  componentDidMount() {
    if (this.props.onFavoriteChange && this.props.poll) {
      return this._poll()
    }
  },

  componentWillUnmount() {
    return clearTimeout(this.poller)
  },

  _handleFavorite(favorite) {
    if (this.props.onFavoriteChange) {
      return this.props.onFavoriteChange(favorite)
    }
  },

  render() {
    const favorites = this.props.favorites.map(favorite => (
      <Column key={favorite.user_id} s={3}>
        <img
          src={favorite.user_avatar_url}
          className="responsive-img avatar"
          alt={favorite.user_id}
          style={{ display: 'block' }}
        />
      </Column>
    ))

    return (
      <Row>
        {favorites}
        {favorites.length <= 0 && (
          <Column>
            <p className="caption center">No favorites yet.</p>
          </Column>
        )}
      </Row>
    )
  },
})
