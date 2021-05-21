import React, { Component } from 'react'
import compose from '../../../utils/compose'
import { withTranslation } from 'react-i18next'
import DiscussionLink from './DiscussionLink'
import { Query } from 'react-apollo'
import getDiscussions from '../getDiscussions.graphql'
import Error from '../../Shared/Error'
import { Link } from 'react-router-dom'
import PostTags, { DropdownTag } from '../shared/PostTags'
import Restrict from '../../Shared/Restrict'
import c from 'classnames'

import NumberUtils from 'v1/utils/NumberUtils'

import Advertisement from 'v1/shared/advertisement'
import Loading from '../../Shared/views/Loading'

class Discussions extends Component {
  constructor(props) {
    super(props)

    this.state = {
      sort: 'recent_comments',
      page: 1,
    }
  }

  renderDiscussions(props) {
    const { forum, t, query } = this.props
    const { data, loading, error } = props
    let content
    let { totalEntries, offset, count } =
      (data && data.getForum && data.getForum.discussions) || {}

    if (loading) {
      content = <Loading />
    } else if (error) {
      content = <Error error={error} />
    } else {
      const { discussions, ...rest } = data.getForum.discussions || []
      console.log({ rest })

      if (discussions.length === 0) {
        content = (
          <p className={'caption center no-content'}>
            {t('content.empty', 'Nothing here :(')}
          </p>
        )
      } else {
        content = discussions.map(discussion => (
          <DiscussionLink
            key={discussion.id}
            forum={forum}
            discussion={discussion}
          />
        ))
      }
    }

    return (
      <div>
        <div className="forum-posts--group-name">
          {query
            ? t('forums.search_posts', 'Search for: {{query}}', { query })
            : t('forums.recent_posts', 'Recent Posts')}

          {totalEntries > 0 && (
            <div className={'right'}>
              {NumberUtils.format(offset + 1)} &ndash;{' '}
              {NumberUtils.format(offset + count)} of{' '}
              {NumberUtils.format(totalEntries)}
            </div>
          )}
        </div>

        {content}
      </div>
    )
  }

  handleSortClick(sortBy) {
    return e => {
      e.preventDefault()
      this.setState({ sort: sortBy })
    }
  }

  render() {
    const { forum, t, query } = this.props
    const { page, sort } = this.state
    const {
      discussions: { discussions, total_entries },
    } = forum

    const i18nDefaults = {
      recent_comments: 'Recent Comments',
      newest_discussions: 'Newest Discussions',
      top_rated: 'Top Rated',
    }

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <div className={'forum-posts--header'}>
            <div className={'right'}>
              <Restrict
                user
                confirmed={forum.slug !== 'support'}
                hideAll={!forum.is_member}
              >
                <Link
                  to={`/forums/${forum.slug}/post`}
                  className={'btn btn-small'}
                >
                  {t('forums.new_discussion', 'New Discussion')}
                </Link>
              </Restrict>
            </div>

            <PostTags>
              <DropdownTag
                icon={'sort'}
                title={t('labels.sort_by', 'Sort By')}
                label={t(`forums.${sort}`, i18nDefaults[sort])}
              >
                <a
                  href={'#'}
                  className={c({ active: sort === 'recent_comments' })}
                  onClick={this.handleSortClick('recent_comments').bind(this)}
                >
                  {t('forums.recent_comments', 'Recent Comments')}
                </a>
                <a
                  href={'#'}
                  className={c({ active: sort === 'newest_discussions' })}
                  onClick={this.handleSortClick('newest_discussions').bind(
                    this
                  )}
                >
                  {t('forums.newest_discussions', 'Newest Discussions')}
                </a>
                <a
                  href={'#'}
                  className={c({ active: sort === 'top_rated' })}
                  onClick={this.handleSortClick('top_rated').bind(this)}
                >
                  {t('forums.top_rated', 'Top Rated')}
                </a>
              </DropdownTag>
            </PostTags>
          </div>

          {discussions.length > 0 && (
            <div className={'stickies'}>
              <div className={'forum-posts--group-name'}>
                {t('forums.sticky_posts', 'Sticky Posts')}
              </div>

              {discussions.map(discussion => (
                <DiscussionLink
                  key={discussion.id}
                  forum={forum}
                  discussion={discussion}
                  slim
                />
              ))}
            </div>
          )}

          <Query
            query={getDiscussions}
            variables={{
              forumId: forum.slug,
              page: this.state.page,
              sort: this.state.sort,
              query: this.props.query,
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

export default compose(withTranslation('common'))(Discussions)
