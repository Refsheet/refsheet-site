import React, { Component } from 'react'
import {Link} from "react-router-dom";
import RichText from "../Shared/RichText";

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
        <Form className='reply-box'
              action={ '/media/' + this.props.mediaId + '/comments' }
              model={ {} }
              modelName='comment'
              onChange={ this._handleComment }
              resetOnSubmit
        >
          <Input type='textarea' name='comment' placeholder='Leave a comment...' noMargin browserDefault className='min-height overline block' />
          <Submit className='btn-square btn-block'>Send Comment <Icon className='right'>send</Icon></Submit>
        </Form>
      </div>
    )
  }

  render() {
    const comment = {
      id: "0bc1",
      created_at: 123758689,
      created_at_human: 'now',
      comment: 'This is a cool picture!',
      user: {
        avatar_url: "https://placehold.it/64x64",
        link: '/Username',
        name: 'User Name'
      }
    }

    const comments = [comment, comment, comment]

    return (
      <div className={'flex-vertical comments'}>
        <div className={'flex-content overflow'}>
          { comments.map(this.renderComment) }
          { comments.length <= 0 && <p className={'caption padding--medium'}>No comments yet!</p> }
        </div>

        { this.renderReplyBox() }
      </div>
    )
  }
}

export default Comments