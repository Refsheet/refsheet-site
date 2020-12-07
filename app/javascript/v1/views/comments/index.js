/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Form from '../../shared/forms/Form'
import Input from '../../shared/forms/Input'
import Submit from '../../shared/forms/Submit'
import Icon from '../../shared/material/Icon'
import RichText from '../../../components/Shared/RichText'
import { Link } from 'react-router-dom'
import Model from '../../utils/Model'
import compose, { withCurrentUser } from '../../../utils/compose'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Index = createReactClass({
  propTypes: {
    mediaId: PropTypes.string.isRequired,
    comments: PropTypes.array,
    poll: PropTypes.bool,
    onCommentChange: PropTypes.func,
    onCommentsChange: PropTypes.func,
  },

  getInitialState() {
    return {
      model: {
        comment: '',
      },
    }
  },

  _poll() {
    return (this.poller = setTimeout(() => {
      return Model.poll(`/media/${this.props.mediaId}/comments`, {}, data => {
        if (this.props.onCommentsChange) {
          this.props.onCommentsChange(data)
        }
        return this._poll()
      })
    }, 3000))
  },

  componentDidMount() {
    if (this.props.onCommentsChange && this.props.poll) {
      return this._poll()
    }
  },

  componentWillUnmount() {
    return clearTimeout(this.poller)
  },

  _handleComment(comment) {
    if (this.props.onCommentChange) {
      return this.props.onCommentChange(comment)
    }
  },

  render() {
    const comments = this.props.comments.map(function (comment) {
      if (comment.user) {
        return (
          <div className="card flat with-avatar" key={comment.id}>
            <img src={comment.user.avatar_url} className="circle avatar" />
            <div className="card-content">
              <div className="muted right" title={comment.created_at}>
                {comment.created_at_human}
              </div>
              <Link to={comment.user.link}>{comment.user.name}</Link>
              <RichText
                contentHtml={comment.comment}
                content={comment.comment}
              />
            </div>
          </div>
        )
      } else {
        return (
          <div className="card flat" key={comment.id}>
            <div className="card-content red-text text-darken-2">
              User Deactivated
            </div>
          </div>
        )
      }
    })

    return (
      <div className="flex-vertical">
        <div className="flex-content overflow" ref="commentBox">
          {comments.reverse()}
          {comments.length <= 0 && (
            <p className="caption padding--medium">No comments yet!</p>
          )}
        </div>

        {this.props.currentUser && (
          <div className="flex-fixed">
            <Form
              className="reply-box"
              action={'/media/' + this.props.mediaId + '/comments'}
              model={this.state.model}
              modelName="comment"
              onChange={this._handleComment}
              resetOnSubmit
            >
              <Input
                type="textarea"
                name="comment"
                placeholder="Leave a comment..."
                noMargin
                browserDefault
                className="min-height overline block"
              />
              <Submit className="btn-square btn-block">
                Send Comment <Icon className="right">send</Icon>
              </Submit>
            </Form>
          </div>
        )}
      </div>
    )
  },
})

export default compose(withCurrentUser())(Index)
