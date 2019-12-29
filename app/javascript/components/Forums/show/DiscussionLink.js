import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Trans, withNamespaces } from 'react-i18next'
import UserLink from '../../Shared/UserLink'
import Moment from 'react-moment'
import { Link } from 'react-router-dom'
import KarmaButton from '../shared/KarmaButton'
import UserAvatar from '../../User/UserAvatar'
import c from 'classnames'

class DiscussionLink extends Component {
  constructor(props) {
    super(props)

    this.state = {
      karmaLoading: false
    }
  }

  onKarmaLoad(value) {
    this.setState({karmaLoading: value})
  }

  render() {
    const { forum, discussion, t } = this.props

    return (
      <div className={c('forum-post', { new: discussion.is_unread })}>
        <div className={'forum-post--votes'}>
          <div className="forum-post--upvote">
            <KarmaButton
              give
              postId={discussion.id}
              forumId={forum.slug}
              onLoading={this.onKarmaLoad.bind(this)}
              disabled={false}
              voted={false}
            />
          </div>

          <div className={'forum-post--karma'}>
            { this.state.karmaLoading ? '...' : (discussion.karma_total || 0) }
          </div>

          <div className="forum-post--downvote">
            <KarmaButton
              take
              postId={discussion.id}
              forumId={forum.slug}
              onLoading={this.onKarmaLoad.bind(this)}
              disabled={false}
              voted={false}
            />
          </div>
        </div>

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

          <div className={'forum-post--meta'}>
            {t('forums.replies', {
              defaultValue: '{{count}} replies',
              count: discussion.reply_count,
            })}
            {discussion.last_post_at && (
              <span className={'last-reply-at'}>
                {' '}
                (
                <Link
                  to={`/v2/forums/${forum.slug}/${discussion.slug}#last`}
                  title={t('forums.go_to_last', 'Go to last post')}
                >
                  <Moment key={'date'} fromNow unix>
                    {discussion.last_post_at}
                  </Moment>
                </Link>
                )
              </span>
            )}
            &nbsp;&bull;&nbsp;<a href={'#'}>{t('forums.save', 'Save')}</a>
          </div>
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
