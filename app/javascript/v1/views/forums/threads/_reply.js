/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Form from "../../../shared/forms/Form"
import Input from "../../../shared/forms/Input"
import Submit from "../../../shared/forms/Submit"
import IdentityAvatar from 'v1/shared/identity_avatar'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Reply; export default Reply = createReactClass({
  contextTypes: {
    currentUser: PropTypes.object,
  },

  propTypes: {
    forumId: PropTypes.string.isRequired,
    threadId: PropTypes.string.isRequired,
    onPost: PropTypes.func,
  },

  getInitialState() {
    return {
      post: {
        content: null,
      },
    }
  },

  _handlePost(post) {
    if (this.props.onPost) {
      return this.props.onPost(post)
    }
  },

  render() {
    if (!this.context.currentUser) {
      return null
    }

    return (
      <Form
        className="card sp with-avatar reply-box"
        action={
          '/forums/' +
          this.props.forumId +
          '/threads/' +
          this.props.threadId +
          '/posts'
        }
        method="POST"
        model={this.state.post}
        modelName="post"
        onChange={this._handlePost}
        resetOnSubmit
      >
        <IdentityAvatar src={this.context.currentUser} />

        <div className="card-content">
          <Input
            type="textarea"
            browserDefault
            name="content"
            placeholder="Leave a reply..."
          />

          <div className="right-align">
            <Submit>Reply</Submit>
          </div>
        </div>
      </Form>
    )
  },
})
