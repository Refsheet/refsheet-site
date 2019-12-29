import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from '../../Shared/Main'
import { forumType } from '../index'
import Jumbotron from '../../Shared/Jumbotron'
import { Link } from 'react-router-dom'
import { withNamespaces } from 'react-i18next'
import DiscussionLink from './DiscussionLink'
import { Query } from 'react-apollo'
import getDiscussions from '../getDiscussions.graphql'

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      sort: 'created_at:desc',
      page: 1,
    }
  }

  renderDiscussions(props) {
    const { forum } = this.props
    const { data, loading, error } = props

    if (loading) {
      return <Loading />
    } else if (error) {
      return <Error error={error} />
    } else {
      const discussions = data.getForum.discussions || []

      return discussions.map(discussion => (
        <DiscussionLink
          key={discussion.id}
          forum={forum}
          discussion={discussion}
        />
      ))
    }
  }

  handleSortClick(sortBy) {
    return (e) => {
      e.preventDefault()
      this.setState({sort: sortBy})
    }
  }

  render() {
    const { forum, t } = this.props

    return (
      <Main title={'Forums'} className={'main-flex split-bg-right'}>
        <Jumbotron short>
          <h1>{forum.name}</h1>
          <p>{forum.description}</p>
        </Jumbotron>

        <div className="tab-row-container">
          <div className="tab-row pushpin" ref="tabRow">
            <div className="container">
              <ul className="tabs">
                <li className={'tab'}>
                  <Link className={''} to={`/v2/forums/${forum.slug}/about`}>
                    {t('forums.about', 'About & Rules')}
                  </Link>
                </li>
                <li className={'tab active'}>
                  <Link className={'active'} to={`/v2/forums/${forum.slug}`}>
                    {t('forums.posts', 'Posts')}
                  </Link>
                </li>
                <li className={'tab'}>
                  <Link className={''} to={`/v2/forums/${forum.slug}/members`}>
                    {t('forums.members', 'Members')}
                  </Link>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <div className={'container container-flex'}>
          <main className={'content-left'}>
            <div className={'forum-posts--header'}>
              <div className={'right'}>
                <a href={'#'} className={'btn btn-small'}>
                  New Discussion
                </a>
              </div>

              <div className={'sort-by'}>
                Sort By: <a href={'#'} onClick={this.handleSortClick('last_comment_at:desc').bind(this)}>Recent Comments</a> |{' '}
                <a href={'#'} onClick={this.handleSortClick('created_at:desc').bind(this)}>Newest Discussions</a> |{' '}
                <a href={'#'} onClick={this.handleSortClick('karma_total:desc').bind(this)}>Top Rated</a>
              </div>
            </div>

            {forum.discussions.length > 0 && (
              <div className={'stickies'}>
                <div className={'forum-posts--group-name'}>
                  {t('forums.sticky_posts', 'Sticky Posts')}
                </div>

                {forum.discussions.map(discussion => (
                  <DiscussionLink
                    key={discussion.id}
                    forum={forum}
                    discussion={discussion}
                  />
                ))}
              </div>
            )}

            <div className="forum-posts--group-name">
              {t('forums.recent_posts', 'Recent Posts')}
            </div>

            <Query query={getDiscussions} variables={{
              forumId: forum.slug,
              page: this.state.page,
              sort: this.state.sort,
            }}>
              {this.renderDiscussions.bind(this)}
            </Query>
          </main>

          <aside className={'sidebar left-pad'}>
            {typeof Advertisement != 'undefined' && <Advertisement />}
          </aside>
        </div>
      </Main>
    )
  }
}

View.propTypes = {
  forum: forumType,
}

const translated = withNamespaces('common')(View)

export default translated
