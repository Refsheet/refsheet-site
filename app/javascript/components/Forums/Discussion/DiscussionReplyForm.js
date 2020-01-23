import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser, withMutations } from '../../../utils/compose'
import M from 'materialize-css'
import CommentForm from '../../Shared/CommentForm'
import { Row, Col } from 'react-materialize'
import postReply from './postReply.graphql'
import Muted from "../../Styled/Muted";

class DiscussionReplyForm extends Component {
  constructor(props) {
    super(props)
  }

  canReply(user) {
    const { forum, discussion } = this.props

    if (!user || forum.locked || discussion.locked) {
      return false
    }

    return true
  }

  handleSubmit({ comment: content, identity }) {
    console.log({ content, identity })

    return this.props.postReply({
      variables: {
        discussionId: this.props.discussion.id,
        userId: identity.userId,
        characterId: identity.characterId,
        content,
      },
    })
  }

  handleSubmitConfirm({ postReply }) {
    M.toast({
      html: 'Reply submitted!',
      displayLength: 3000,
      classes: 'green',
    })

    if (this.props.refetch) this.props.refetch()
  }

  render() {
    const { currentUser, inCharacter } = this.props

    if (!this.canReply(currentUser)) {
      return null
    }

    return (
      <div id='reply' className={'margin-top--medium forum-post--reply'}>
        <CommentForm
          richText
          v2Style
          inCharacter={inCharacter}
          onSubmit={this.handleSubmit.bind(this)}
          onSubmitConfirm={this.handleSubmitConfirm.bind(this)}
          placeholder={'Leave a reply...'}
          value={''}
          buttonText={'Post Reply'}
          buttonSubmittingText={'Posting...'}
        />

        <Row>
          <Col s={12} m={10} offset={'m1'}>
            <Muted className={'margin-top--medium center'}>
              Before posting, please make sure you've read the forum rules, and
              be sure your post doesn't violate them. Remember: be excellent to
              each other.
            </Muted>
          </Col>
        </Row>
      </div>
    )
  }
}

DiscussionReplyForm.propTypes = {
  discussion: PropTypes.object.isRequired,
  forum: PropTypes.object.isRequired,
  inCharacter: PropTypes.bool,
  refetch: PropTypes.func,
}

export default compose(
  withCurrentUser(),
  withMutations({ postReply })
)(DiscussionReplyForm)
