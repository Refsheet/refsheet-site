import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser, withMutations } from '../../../utils/compose'
import M from 'materialize-css'
import CommentForm from '../../Shared/CommentForm'
import { Row, Col } from 'react-materialize'
import postReply from './postReply.graphql'
import editReply from './editReply.graphql'
import Muted from '../../Styled/Muted'

class DiscussionReplyForm extends Component {
  constructor(props) {
    super(props)
  }

  canReply(user) {
    const { forum, discussion, edit } = this.props
    if (edit) return true

    if (!user || forum.locked || discussion.locked) {
      return false
    }

    return true
  }

  handleSubmit({ comment: content, identity }) {
    const { edit, post, discussion, postReply, editReply } = this.props

    if (edit) {
      return editReply({
        variables: {
          postId: post.id,
          userId: identity.userId,
          content: content,
        },
      })
    }

    return postReply({
      variables: {
        discussionId: discussion.id,
        userId: identity.userId,
        characterId: identity.characterId,
        content,
      },
    })
  }

  handleSubmitConfirm({ postReply, editReply }) {
    const { edit } = this.props

    M.toast({
      html: edit ? 'Reply edited!' : 'Reply submitted!',
      displayLength: 3000,
      classes: 'green',
    })

    if (this.props.refetch) this.props.refetch()
    if (this.props.onSubmit) this.props.onSubmit(postReply || editReply)
  }

  render() {
    const { currentUser, inCharacter, edit, post = {}, onCancel } = this.props
    console.log({ edit, post })

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
        />

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
}

export default compose(
  withCurrentUser(),
  withMutations({ postReply, editReply })
)(DiscussionReplyForm)
