import React, { Component } from 'react'
import { withTranslation } from 'react-i18next'
import { Icon } from 'react-materialize'
import { Link } from 'react-router-dom'
import c from 'classnames'
import compose, { withMutations } from '../../../utils/compose'
import addFavorite from './addFavorite.graphql'
import removeFavorite from './removeFavorite.graphql'
import { connect } from 'react-redux'

class Favorites extends Component {
  constructor(props) {
    super(props)

    this.state = {
      dirty: false,
      isFavorite: false,
      favorite: null,
      ignoreIds: [],
    }
  }

  handleFavoriteClick(e) {
    e.preventDefault()

    const { mediaId, addFavorite, removeFavorite } = this.props

    let { isFavorite } = this.props

    if (this.state.dirty) {
      isFavorite = this.state.isFavorite
    }

    if (isFavorite) {
      removeFavorite({
        variables: {
          mediaId,
        },
      })
        .then(({ data }) => {
          console.log({ data })
          this.setState({
            dirty: true,
            isFavorite: false,
            favorite: data.removeFavorite,
            ignoreIds: [...this.state.ignoreIds, data.removeFavorite.id],
          })
        })
        .catch(console.error)
    } else {
      addFavorite({
        variables: {
          mediaId,
        },
      })
        .then(({ data }) => {
          console.log({ data })
          this.setState({
            dirty: true,
            isFavorite: true,
            favorite: data.addFavorite,
          })
        })
        .catch(console.error)
    }
  }

  render() {
    const { currentUser, t } = this.props

    let { isFavorite, favorites, count = 0 } = this.props

    if (this.state.dirty) {
      isFavorite = this.state.isFavorite

      if (isFavorite) {
        if (!this.props.isFavorite) {
          count += 1

          favorites = [this.state.favorite, ...favorites]
        }
      } else {
        if (this.props.isFavorite) {
          count -= 1

          favorites = favorites.filter(
            f => this.state.ignoreIds.indexOf(f.id) === -1
          )
        }
      }
    }

    return (
      <div className={'favorites card flat'}>
        {currentUser && (
          <a
            href={'#'}
            onClick={this.handleFavoriteClick.bind(this)}
            title={
              isFavorite
                ? t('actions.remove_favorite', 'Remove Favorite')
                : t('actions.add_favorite', 'Add Favorite')
            }
          >
            <Icon className={c('left', { isFavorite })}>star</Icon>
          </a>
        )}

        {favorites.map(favorite => (
          <Link
            to={`/${favorite.user.username}`}
            title={`${favorite.user.name} (@${favorite.user.username})`}
            key={favorite.id}
          >
            <img
              src={favorite.user.avatar_url}
              alt={t('caption.avatar_of', 'Avatar of {{name}}', {
                name: favorite.user.name,
              })}
              className={'avatar circle'}
            />
          </Link>
        ))}

        <span className={'fav-summary'}>
          <a
            href={'#favs'}
            title={t('actions.show_all_favorites', 'Show All Favorites')}
          >
            {t('media.favorites', '{{count}} Favorites', { count })}
          </a>
        </span>

        <br className={'clearfix'} />
      </div>
    )
  }
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
})

export default compose(
  withMutations({ addFavorite, removeFavorite }),
  withTranslation('common'),
  connect(mapStateToProps)
)(Favorites)
