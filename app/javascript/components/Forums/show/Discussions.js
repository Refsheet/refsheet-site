import React, { Component } from 'react'
import compose from '../../../utils/compose'
import { withNamespaces } from 'react-i18next'
import DiscussionLink from './DiscussionLink'
import { Query } from 'react-apollo'
import getDiscussions from '../getDiscussions.graphql'
import Error from '../../Shared/Error'
import { Link } from 'react-router-dom'
import PostTags, { DropdownTag } from '../shared/PostTags'

class Discussions extends Component {
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
    return e => {
      e.preventDefault()
      this.setState({ sort: sortBy })
    }
  }

  render() {
    const { forum, t } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <div className={'forum-posts--header'}>
            <div className={'right'}>
              <Link
                to={`/v2/forums/${forum.slug}/post`}
                className={'btn btn-small'}
              >
                {t('forums.new_discussion', 'New Discussion')}
              </Link>
            </div>

            <PostTags>
              <DropdownTag icon={'sort'} label={t('labels.sort_by', 'Sort By')}>
                <a
                  href={'#'}
                  onClick={this.handleSortClick('last_comment_at:desc').bind(
                    this
                  )}
                >
                  {t('forums.recent_comments', 'Recent Comments')}
                </a>
                <a
                  href={'#'}
                  onClick={this.handleSortClick('created_at:desc').bind(this)}
                >
                  {t('forums.newest_discussions', 'Newest Discussions')}
                </a>
                <a
                  href={'#'}
                  onClick={this.handleSortClick('karma_total:desc').bind(this)}
                >
                  {t('forums.top_rated', 'Top Rated')}
                </a>
              </DropdownTag>
            </PostTags>
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

          <Query
            query={getDiscussions}
            variables={{
              forumId: forum.slug,
              page: this.state.page,
              sort: this.state.sort,
            }}
          >
            {this.renderDiscussions.bind(this)}
          </Query>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

export default compose(withNamespaces('common'))(Discussions)
