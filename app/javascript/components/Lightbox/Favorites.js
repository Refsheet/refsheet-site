import React, { Component } from 'react'
import {withNamespaces} from "react-i18next";
import {Link} from "react-router-dom";

class Favorites extends Component {
  renderSummary(featuredUser, total) {
    const { t } = this.props

    if (featuredUser) {
      return (
        <span className={'fav-summary'}>
          Liked by <span className={'user-you-know'}><Link to={`/${featuredUser.username}`}>{ featuredUser.name }</Link> and </span>
          <a href={'#favs'}>{ total } others</a>
        </span>
      )
    } else {
      return (
        <span className={'fav-summary'}>
          <a href={'#favs'}>
            { t('media.favorites', '{{count}} Favorites', { count: total }) }
          </a>
        </span>
      )
    }
  }

  render() {
    const featuredUser = null;
    const users = [
      {
        username: 'someuser',
        name: 'Some User',
        avatarUrl: 'https://placehold.it/64x64'
      },
      {
        username: 'someuser',
        name: 'Some User',
        avatarUrl: 'https://placehold.it/64x64'
      },
      {
        username: 'someuser',
        name: 'Some User',
        avatarUrl: 'https://placehold.it/64x64'
      }
    ]
    const total = 37064

    return (
      <div className={'favorites card flat'}>
        { users.map(user => (
          <Link to={`/${user.username}`} title={`${user.name} (@${user.username})`}>
            <img src={user.avatarUrl} alt={`Avatar of ${user.name}`} className={'avatar circle'} />
          </Link>
        ))}

        { this.renderSummary(users.first, total) }
      </div>
    )
  }
}

export default withNamespaces('common')(Favorites)