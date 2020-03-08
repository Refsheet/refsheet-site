import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Trans, withNamespaces } from 'react-i18next'
import UserLink from '../../Shared/UserLink'
import Moment from 'react-moment'
import { Link } from 'react-router-dom'
import UserAvatar from '../../User/UserAvatar'
import c from 'classnames'
import KarmaCounter from '../shared/KarmaCounter'
import PostMeta from '../shared/PostMeta'

class DiscussionLink extends Component {
  render() {
    const { forum, discussion, t } = this.props

    return (
      <div
        className={c('forum-post card', {
          new: discussion.is_unread,
          admin: discussion.admin_post,
          moderator: discussion.moderator_post,
        })}
      >
        <KarmaCounter
          discussion={discussion}
          forum={forum}
          className={'shade'}
        />

        <div className={'forum-post--summary'}>
          <div className="forum-post--title">
            {discussion.is_unread && <span className={'tag new'}>New</span>}
            {discussion.sticky && <span className={'tag alert'}>Sticky</span>}
            {discussion.is_resolved && (
              <span className={'tag resolved'}>Resolved</span>
            )}

            <Link
              to={`/v2/forums/${forum.slug}/${discussion.slug}`}
              title={discussion.topic}
            >
              {discussion.topic}
            </Link>
          </div>

          <div className={'forum-post--preview'}>{discussion.preview}</div>

          <PostMeta forum={forum} discussion={discussion} />
        </div>

        <div className="forum-post--date">
          <div className={'user-summary'}>
            <UserAvatar
              user={discussion.user}
              character={discussion.character}
            />

            <UserLink user={discussion.user} character={discussion.character} />

            <div className={'time'}>
              <Trans
                i18nKey={'forums.summary-posted-date'}
                defaults={'Posted <0>{{ date }}</0>'}
                values={{
                  date: discussion.created_at,
                }}
                components={[
                  <Moment key={'date'} fromNow unix>
                    {discussion.created_at}
                  </Moment>,
                ]}
              />
            </div>
          </div>
        </div>
      </div>
    )
  }
}

DiscussionLink.propTypes = {}

const translated = withNamespaces('common')(DiscussionLink)

export default translated
