import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import UserAvatar from '../../User/UserAvatar'
import { Trans } from 'react-i18next'
import Moment from 'react-moment'
import UserLink from '../../Shared/UserLink'
import PostMeta from '../shared/PostMeta'
import RichText from '../../Shared/RichText'

class DiscussionReply extends Component {
  render() {
    const { post } = this.props

    return (
      <div className={'margin-top--medium forum-post--reply'}>
        <UserAvatar user={post.user} character={post.character} />

        <div className={'time'}>
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
        </div>

        <div className={'forum-post--whodunnit'}>
          <UserLink user={post.user} character={post.character} />
        </div>

        <div className={'reply-content'}>
          <RichText content={post.content} contentHtml={post.content_html} />
        </div>
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
