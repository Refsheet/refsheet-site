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
import { Icon, Dropdown } from 'react-materialize'
import Muted, { MutedAnchor } from '../../Styled/Muted'
import { div as Card } from '../../Styled/Card'
import DiscussionReplyForm from './DiscussionReplyForm'

class DiscussionReply extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
    }
  }

  handleEditStart(e) {
    e.preventDefault()
    this.setState({ editing: true })
  }

  handleEditStop() {
    this.setState({ editing: false })
  }

  handleSubmit(post) {
    this.setState({ editing: false })
    this.props.refetch && this.props.refetch()
  }

  render() {
    const { post, discussionId, forumId } = this.props

    if (this.state.editing) {
      return (
        <DiscussionReplyForm
          edit
          post={post}
          onSubmit={this.handleSubmit.bind(this)}
          onCancel={this.handleEditStop.bind(this)}
        />
      )
    }

    return (
      <div className={'margin-top--medium forum-post--reply'}>
        <UserAvatar user={post.user} character={post.character} />

        <Card
          className={c('forum-reply card sp', {
            admin: post.admin_post,
            moderator: post.moderator_post,
          })}
        >
          <div className={'forum-post--whodunnit card-header'}>
            <div className={'time right smaller'}>
              <MutedAnchor
                href={LinkUtils.forumPostUrl({
                  forumId,
                  discussionId,
                  postId: post.id,
                })}
                title={'Copy Permalink'}
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

              {post.is_edited && (
                <Muted className={'margin-left--small inline'}>
                  (
                  <a href={'#'} title={'Show edit history...'}>
                    Edited
                  </a>
                  )
                </Muted>
              )}

              <Dropdown
                trigger={
                  <MutedAnchor href={'#'}>
                    <Icon className={'right smaller'}>more_vert</Icon>
                  </MutedAnchor>
                }
              >
                <a href={'#'} onClick={this.handleEditStart.bind(this)}>
                  Edit
                </a>
                <a href={'#'}>Delete</a>
                <a href={'#'}>Report</a>
              </Dropdown>
            </div>

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
