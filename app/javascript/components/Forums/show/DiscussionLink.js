import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Trans, withNamespaces } from 'react-i18next'
import UserLink from '../../Shared/UserLink'
import Moment from 'react-moment'
import { Link } from 'react-router-dom'
import KarmaButton from '../shared/KarmaButton'
import UserAvatar from "../../User/UserAvatar";
import c from 'classnames'

class DiscussionLink extends Component {
  render() {
    const { forum, discussion, t } = this.props

    console.log({ discussion })

    return (
      <div className={c('forum-post', {new: discussion.is_unread})}>
        <div className={'forum-post--votes'}>
          <div className="forum-post--upvote">
            <KarmaButton
              give
              postId={discussion.id}
              disabled={false}
              voted={false}
            />
          </div>

          <div className={'forum-post--karma'}>
            {discussion.karma_total || 0}
          </div>

          <div className="forum-post--downvote">
            <KarmaButton
              take
              postId={discussion.id}
              disabled={false}
              voted={false}
            />
          </div>
        </div>

        <div className={'forum-post--summary'}>
          <div className="forum-post--title">
            { discussion.is_unread && <span className={'new'}>New</span> }
            <Link
              to={`/v2/forums/${forum.slug}/${discussion.slug}`}
              title={discussion.topic}
            >
              {discussion.topic}
            </Link>
          </div>

          <div className={'forum-post--preview'}>
            { JSON.stringify(discussion.preview) }
          </div>

          <div className={'forum-post--meta'}>
            {t('forums.replies', {
              defaultValue: '{{count}} replies',
              count: 0,
            })}

            &nbsp;&bull;&nbsp;<a href={'#'}>{t('forums.save', "Save")}</a>
          </div>
        </div>

        <div className="forum-post--date">
          <div className={'user-summary'}>
            <UserAvatar
              user={discussion.user}
              character={discussion.character}
            />

            <UserLink
              user={discussion.user}
              character={discussion.character}
            />

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
