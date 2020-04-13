import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Modal from 'v1/shared/Modal'
import Form from 'v1/shared/forms/Form'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'
import Input from 'v1/shared/forms/Input'
import Submit from 'v1/shared/forms/Submit'

import * as Materialize from 'materialize-css'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let FeedbackModal
export default FeedbackModal = createReactClass({
  propTypes: {
    name: PropTypes.string,
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
    this.refs.modal.close()
    Materialize.toast({
      html: 'Thanks for the feedback!',
      displayLength: 3000,
      classes: 'green',
    })
    return this.setState({ model: { comment: null } })
  },

  _handleClose(e) {
    this.refs.modal.close()
    return e.preventDefault()
  },

  render() {
    return (
      <Modal id="feedback-modal" ref="modal" title="Feedback">
        <p>Something not quite right? Want a new feature? Let me know!</p>

        <Form
          onChange={this._handleSubmit}
          action="/feedbacks"
          className="margin-top--large"
          model={this.state.model}
          modelName="feedback"
        >
          <Row>
            <Column m={6}>
              <Input
                type="text"
                name="name"
                label="Your Name"
                autoFocus={!this.state.model.name}
              />
            </Column>
            <Column m={6}>
              <Input type="text" name="email" label="Your Email" />
            </Column>
          </Row>

          <Input
            type="textarea"
            name="comment"
            label="Comment"
            autoFocus={!!this.state.model.name}
          />

          <Row className="actions right-align">
            <Column>
              <Submit>Send Feedback</Submit>
            </Column>
          </Row>
        </Form>
      </Modal>
    )
  },
})
