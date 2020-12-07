/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import $ from 'jquery'
import compose, { withCurrentUser } from '../../../utils/compose'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const FavoriteButton = createReactClass({
  propTypes: {
    mediaId: PropTypes.string.isRequired,
    favorites: PropTypes.array,
    isFavorite: PropTypes.bool,
    onChange: PropTypes.func,
    onFavorite: PropTypes.func,
  },

  _isFavFromProps(props) {
    if (typeof props.isFavorite === 'undefined') {
      if (!props.favorites) {
        return false
      }
      return (
        props.favorites.filter(fav => {
          return fav.user_id === this.props.currentUser.username
        }).length > 0
      )
    } else {
      return props.isFavorite
    }
  },

  getInitialState() {
    return { isFavorite: this._isFavFromProps(this.props) }
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    return this.setState({ isFavorite: this._isFavFromProps(this.props) })
  },

  _handleFavorite(e) {
    const path = `/media/${this.props.mediaId}`

    if (!this.state.isFavorite) {
      $.post(path + '/favorites', data => {
        this.setState({ isFavorite: true })
        if (this.props.onChange) {
          this.props.onChange(true)
        }
        if (this.props.onFavorite) {
          return this.props.onFavorite(data, true)
        }
      })
    } else {
      $.ajax({
        url: path + '/favorite',
        type: 'DELETE',
        success: data => {
          this.setState({ isFavorite: false })
          if (this.props.onChange) {
            this.props.onChange(false)
          }
          if (this.props.onFavorite) {
            return this.props.onFavorite(data, false)
          }
        },
      })
    }
    return e.preventDefault()
  },

  render() {
    const favoriteClassName = this.state.isFavorite
      ? 'favorite'
      : 'not-favorite'

    return (
      <div
        className={'favorite-button ' + favoriteClassName}
        onClick={this._handleFavorite}
      >
        <i className="material-icons">star</i>
      </div>
    )
  },
})

export default compose(withCurrentUser())(FavoriteButton)
