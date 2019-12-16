import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {Link} from "react-router-dom";
import removeComment from './removeComment.graphql'
import compose, {withCurrentUser, withMutations} from "../../utils/compose";
import CommentForm from "../Shared/CommentForm";
import addComment from './addComment.graphql'

class Comments extends Component {
  renderComment(comment) {
    return (
      <div className='card flat with-avatar' key={ comment.id }>
        <img src={ comment.user.avatar_url } className='circle avatar' />
        <div className='card-content'>
          <div className='muted right' title={ comment.created_at }>{ comment.created_at_human }</div>
          <Link to={ `/${comment.user.username}` }>{ comment.user.name }</Link>
          <div className={'comment-content'}>
            { comment.comment }
          </div>
        </div>
      </div>
    )
  }

  handleSubmit({comment, identity}) {
    const {
      mediaId,
      addComment
    } = this.props

    const variables = {
      mediaId,
      comment
    }

    return addComment({
      variables
    })
  }

  render() {
    const {
      comments,
      count = 0,
      isManaged,
      currentUser
    } = this.props

    return (
      <div className={'flex-vertical comments'}>
        <div className={'flex-content overflow'}>
          { comments.map(this.renderComment) }
          { comments.length <= 0 && <p className={'caption padding--medium center'}>No comments yet!</p> }
        </div>

        { currentUser && <div className='flex-fixed'>
          <CommentForm slim
                       placeholder={"Add comment..."}
                       buttonText={"Send"}
                       onSubmit={this.handleSubmit.bind(this)}
                       buttonSubmittingText={"Sending"}
          />
        </div> }
      </div>
    )
  }
}

Comments.propTypes = {
  mediaId: PropTypes.string.isRequired,
}

export default compose(
  withMutations({removeComment, addComment}),
  withCurrentUser()
)(Comments)
