/* eslint-disable
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let NewActivity; export default NewActivity = createReactClass({
  contextTypes: {
    currentUser: PropTypes.object,
  },

  getInitialState() {
    return {
      model: {
        name: this.props.name,
        comment: null,
      },
    }
  },

  _handleSubmit(feedback) {
    Materialize.toast({
      html: 'Thanks for the feedback!',
      displayLength: 3000,
      classes: 'green',
    })
    return this.setState({ model: { comment: null } })
  },

  render() {
    return (
      <Form
        className="card reply-box margin-top--none sp with-avatar"
        onChange={this._handleSubmit}
        action="/feedbacks"
        model={this.state.model}
        modelName="feedback"
      >
        <img
          className="avatar circle"
          src={this.context.currentUser.avatar_url}
          alt={this.context.currentUser.name}
        />

        <div className="card-content reply-box">
          <Input
            type="textarea"
            name="comment"
            browserDefault
            noMargin
            placeholder="Would status updates be helpful? Submit a feedback request!"
          />

          <Row noMargin>
            <Column s={8}></Column>
            <Column s={4}>
              <Submit className="btn-block">Feedback!</Submit>
            </Column>
          </Row>
        </div>
      </Form>
    )
  },
})
