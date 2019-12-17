import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Trans, withNamespaces } from 'react-i18next'
import UserLink from '../../Shared/UserLink'
import Moment from 'react-moment'
import { Link } from 'react-router-dom'
import KarmaButton from '../shared/KarmaButton'

class DiscussionLink extends Component {
  render() {
    const { forum, discussion, t } = this.props

    return (
      <div className={'forum-post'}>
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
            <Link
              to={`/v2/forums/${forum.slug}/${discussion.slug}`}
              title={discussion.topic}
            >
              {discussion.topic}
            </Link>
          </div>

          <div className="forum-post--date">
            <Trans
              i18nKey={'forums.post-date'}
              defaults={'Submitted <0>{{ date }}</0> by <1></1>'}
              values={{
                date: discussion.created_at,
              }}
              components={[
                <Moment key={'date'} fromNow unix>
                  {discussion.created_at}
                </Moment>,
                <UserLink
                  key={'user'}
                  user={discussion.user}
                  character={discussion.character}
                />,
              ]}
            />
          </div>

          <div className={'forum-post--meta'}>
            {t('forums.replies', {
              defaultValue: '{{count}} reply',
              count: 0,
            })}

            {/*&nbsp;| <a href={'#'}>{t('forums.save', "Save")}</a>*/}
          </div>
        </div>
      </div>
    )
  }
}

DiscussionLink.propTypes = {}

const translated = withNamespaces('common')(DiscussionLink)

export default translated
