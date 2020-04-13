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
import * as Materialize from 'materialize-css'
import Form from '../../../shared/forms/Form'
import Input from '../../../shared/forms/Input'
import Row from '../../../shared/material/Row'
import Submit from '../../../shared/forms/Submit'
import Modal from '../../../shared/Modal'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ThreadModal
export default ThreadModal = createReactClass({
  contextTypes: {
    router: PropTypes.object.isRequired,
  },

  propTypes: {
    forumId: PropTypes.string.isRequired,
  },

  getInitialState() {
    return {
      thread: {
        topic: null,
        content: null,
      },
    }
  },

  _handleCreate(thread) {
    Materialize.toast({
      html: "Thread created! Hope it's a good one :)",
      displayLength: 3000,
      classes: 'green',
    })
    this.refs.modal.close()
    console.log(thread)
    return this.context.router.history.push(thread.path)
  },

  render() {
    return (
      <Modal id="new-thread-modal" title="New Thread" ref="modal">
        <Form
          action={'/forums/' + this.props.forumId + '/threads'}
          method="POST"
          model={this.state.thread}
          modelName="thread"
          onChange={this._handleCreate}
          className="reply-box not-really-tho"
        >
          <Input name="topic" label="Topic" />
          <Input
            name="content"
            placeholder="What would you like to say?"
            type="textarea"
            browserDefault
          />

          <Row className="actions right-align" oneColumn>
            <Submit id={'thread_submit'}>Start Thread</Submit>
          </Row>
        </Form>
      </Modal>
    )
  },
})
