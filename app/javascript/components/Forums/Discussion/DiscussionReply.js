import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import UserAvatar from '../../User/UserAvatar'
import { Trans } from 'react-i18next'
import Moment from 'react-moment'
import UserLink from '../../Shared/UserLink'
import PostMeta from '../shared/PostMeta'
import RichText from '../../Shared/RichText'
import LinkUtils from 'utils/LinkUtils'
import c from 'classnames'
import {MutedAnchor} from "../../Styled/Muted";
import { div as Card } from "../../Styled/Card";

class DiscussionReply extends Component {
  render() {
    const { post, discussionId, forumId } = this.props

    return (
      <div className={'margin-top--medium forum-post--reply'}>
        <UserAvatar user={post.user} character={post.character} />

        <Card className={c('forum-reply card sp', { admin: post.admin_post, moderator: post.moderator_post})}>
          <div className={'time right smaller card-header'}>
            <MutedAnchor
              href={LinkUtils.forumPostUrl({
                forumId,
                discussionId,
                postId: post.id,
              })}
            >
              <Trans
                i18nKey={'forums.summary-posted-date'}
                defaults={'Posted <0>{{ date }}</0>'}
                values={{
                  date: post.created_at,
                }}
                components={[
                  <Moment key={'date'} fromNow unix>
                    {post.created_at}
                  </Moment>,
                ]}
              />
            </MutedAnchor>
          </div>

          <div className={'forum-post--whodunnit card-header'}>
            <UserLink user={post.user} character={post.character} />
          </div>

          <div className={'reply-content card-content'}>
            <RichText content={post.content} contentHtml={post.content_html} />
          </div>
        </Card>
      </div>
    )
  }
}

DiscussionReply.propTypes = {
  post: PropTypes.object.isRequired,
  discussion: PropTypes.object,
}

export default compose()(DiscussionReply)
// TODO: Add HOC bindings here
