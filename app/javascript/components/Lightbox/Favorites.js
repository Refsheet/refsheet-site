import React, { Component } from 'react'
import {withNamespaces} from "react-i18next";
import { Icon } from 'react-materialize'
import {Link} from "react-router-dom";
import c from 'classnames'
import compose, {withMutations} from "../../utils/compose";
import addFavorite from './addFavorite.graphql'
import removeFavorite from './removeFavorite.graphql'
import {connect} from "react-redux";

class Favorites extends Component {
  handleFavoriteClick(e) {
    e.preventDefault()

    const {
      mediaId,
      isFavorite,
      addFavorite,
      removeFavorite
    } = this.props

    if (isFavorite) {
      removeFavorite({
        variables: {
          mediaId
        }
      })
        .then(console.log)
        .catch(console.error)
    } else {
      addFavorite({
        variables: {
          mediaId
        }
      })
        .then(console.log)
        .catch(console.error)
    }
  }

  render() {
    const {
      favorites,
      count = 0,
      isFavorite,
      currentUser,
      t
    } = this.props

    return (
      <div className={'favorites card flat'}>
        { currentUser && <a href={'#'} onClick={this.handleFavoriteClick.bind(this)} title={isFavorite
          ? t('actions.remove_favorite', "Remove Favorite")
          : t('actions.add_favorite', "Add Favorite")}>
          <Icon className={c('left', { isFavorite })}>star</Icon>
        </a>}

        { favorites.map(favorite => (
          <Link to={`/${favorite.user.username}`} title={`${favorite.user.name} (@${favorite.user.username})`} key={favorite.id}>
            <img src={favorite.user.avatar_url} alt={t('caption.avatar_of', "Avatar of {{name}}", { name: favorite.user.name })} className={'avatar circle'} />
          </Link>
        ))}

        <span className={'fav-summary'}>
          <a href={'#favs'} title={t('actions.show_all_favorites', 'Show All Favorites')}>
            { t('media.favorites', '{{count}} Favorites', { count }) }
          </a>
        </span>
      </div>
    )
  }
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser
})

export default compose(
  withMutations({addFavorite, removeFavorite}),
  withNamespaces('common'),
  connect(mapStateToProps)
)(Favorites)