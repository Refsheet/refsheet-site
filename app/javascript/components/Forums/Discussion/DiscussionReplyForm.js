import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser, withMutations } from '../../../utils/compose'
import M from 'materialize-css'
import CommentForm from '../../Shared/CommentForm'
import { Row, Col } from 'react-materialize'
import postReply from './postReply.graphql'
import editReply from './editReply.graphql'
import createDiscussion from '../NewDiscussion/createDiscussion.graphql'
import Muted from '../../Styled/Muted'

class DiscussionReplyForm extends Component {
  constructor(props) {
    super(props)
  }

  canReply(user) {
    // TODO: Use a policy for this.
    const { forum, discussion, edit } = this.props
    if (!user) return false
    if (edit) return true
    if (user.is_admin) return true

    return !(forum && forum.locked) || (discussion && discussion.locked)
  }

  handleSubmit({ comment: content, identity }) {
    const {
      edit,
      post,
      discussion,
      postReply,
      editReply,
      newDiscussion,
      createDiscussion,
      forum,
    } = this.props

    if (edit) {
      return editReply({
        wrapped: true,
        variables: {
          postId: post.id,
          userId: identity.userId,
          content: content,
        },
      })
    }

    if (newDiscussion) {
      return createDiscussion({
        wrapped: true,
        variables: {
          forumId: forum.slug,
          locked: post.locked,
          topic: post.topic,
          content: content,
          sticky: post.sticky,
        },
      })
    }

    return postReply({
      wrapped: true,
      variables: {
        discussionId: discussion.id,
        userId: identity.userId,
        characterId: identity.characterId,
        content,
      },
    })
  }

  handleSubmitConfirm({ postReply, editReply, createDiscussion }) {
    const { edit } = this.props

    M.toast({
      html: edit ? 'Reply edited!' : 'Reply submitted!',
      displayLength: 3000,
      classes: 'green',
    })

    if (this.props.refetch) this.props.refetch()
    if (this.props.onSubmit)
      this.props.onSubmit(postReply || editReply || createDiscussion)
  }

  render() {
    const {
      currentUser,
      inCharacter,
      edit,
      post = {},
      onCancel,
      children,
    } = this.props

    if (!this.canReply(currentUser)) {
      return null
    }

    return (
      <div id="reply" className={'margin-top--medium forum-post--reply'}>
        <CommentForm
          richText
          v2Style
          hashtags
          emoji
          inCharacter={inCharacter && !edit}
          onSubmit={this.handleSubmit.bind(this)}
          onSubmitConfirm={this.handleSubmitConfirm.bind(this)}
          onCancel={onCancel}
          placeholder={'Leave a reply...'}
          value={post.content || ''}
          buttonText={edit ? 'Edit Reply' : 'Post Reply'}
          buttonSubmittingText={'Posting...'}
        >
          {children}
        </CommentForm>

        <Row>
          <Col s={12} m={10} offset={'m1'}>
            {edit ? (
              <Muted className={'margin-top--medium center'}>
                The content of this post can be edited, but previous versions
                will still be visible via the edit history.
              </Muted>
            ) : (
              <Muted className={'margin-top--medium center'}>
                Before posting, please make sure you've read the forum rules,
                and be sure your post doesn't violate them. Remember: be
                excellent to each other.
              </Muted>
            )}
          </Col>
        </Row>
      </div>
    )
  }
}

DiscussionReplyForm.propTypes = {
  edit: PropTypes.bool,
  post: PropTypes.object,
  discussion: PropTypes.object,
  forum: PropTypes.object,
  inCharacter: PropTypes.bool,
  refetch: PropTypes.func,
  onSubmit: PropTypes.func,
}

export default compose(
  withCurrentUser(),
  withMutations({ postReply, editReply, createDiscussion })
)(DiscussionReplyForm)
