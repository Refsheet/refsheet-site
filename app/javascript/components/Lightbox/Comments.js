import React, { Component } from 'react'
import {Link} from "react-router-dom";
import removeComment from './removeComment.graphql'
import compose, {withCurrentUser, withMutations} from "../../utils/compose";
import CommentForm from "../Shared/CommentForm";

class Comments extends Component {
  renderComment(comment) {
    return (
      <div className='card flat with-avatar' key={ comment.id }>
        <img src={ comment.user.avatar_url } className='circle avatar' />
        <div className='card-content'>
          <div className='muted right' title={ comment.created_at }>{ comment.created_at_human }</div>
          <Link to={ comment.user.link }>{ comment.user.name }</Link>
          <div className={'comment-content'}>
            { comment.comment }
          </div>
        </div>
      </div>
    )
  }

  renderReplyBox() {
    return (
      <div className='flex-fixed'>
        <CommentForm slim placeholder={"What say you?"} buttonText={"Send"} buttonSubmittingText={"Sending"} />
      </div>
    )
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
          { comments.length <= 0 && <p className={'caption padding--medium'}>No comments yet!</p> }
        </div>

        { this.props.currentUser && this.renderReplyBox() }
      </div>
    )
  }
}

export default compose(
  withMutations({removeComment}),
  withCurrentUser()
)(Comments)
