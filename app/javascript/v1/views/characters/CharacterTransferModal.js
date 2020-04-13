/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import Modal from '../../shared/Modal'
import Form from '../../shared/forms/Form'
import Row from '../../shared/material/Row'
import Column from '../../shared/material/Column'
import Input from '../../shared/forms/Input'
import Submit from '../../shared/forms/Submit'

import $ from 'jquery'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CharacterTransferModal
export default CharacterTransferModal = createReactClass({
  propTypes: {
    character: PropTypes.object.isRequired,
  },

  getInitialState() {
    return {
      dirty: false,
      model: {
        transfer_to_user: null,
      },
    }
  },

  _handleModalClose(e) {
    return Materialize.Modal.getInstance(
      document.getElementById('character-transfer-modal')
    ).close()
  },

  _handleChange(character) {
    this.setState({ model: { transfer_to_user: null } })
    $(document).trigger('app:character:update', character)

    this._handleModalClose()
    return Materialize.toast({
      html: 'Character transfer initiated.',
      displayLength: 3000,
      classes: 'green',
    })
  },

  _handleCancel(e) {
    this.refs.form.reset()
    this._handleModalClose()
    return e.preventDefault()
  },

  _handleDirty(dirty) {
    return this.setState({ dirty })
  },

  render() {
    return (
      <Modal id="character-transfer-modal" title="Character Transfer">
        <Form
          action={this.props.character.path}
          method="PUT"
          modelName="character"
          model={this.state.model}
          onChange={this._handleChange}
          onDirty={this._handleDirty}
          ref="form"
        >
          <p>
            If you wish to transfer a character, and <strong>all</strong> the
            art assets and history attached, enter the destination username or
            email below.
          </p>
          <p>
            If the user does not have an account, they will be sent an email
            prompting them to create one before accepting this transfer.
          </p>
          <p>
            This character transfer, if accepted, will be recorded in the
            character's history. You will not be able to recall this character.
            All rights to this character's file will be reassigned.
          </p>

          <Row noMargin>
            <Column>
              <Input
                name="transfer_to_user"
                label="Destination Email or Username"
                autoFocus
              />
            </Column>
          </Row>

          <Row hidden={!this.state.dirty} className="actions">
            <Column>
              <a className="btn btn-secondary" onClick={this._handleCancel}>
                Cancel
              </a>
              <div className="right">
                <Submit>Send Transfer</Submit>
              </div>
            </Column>
          </Row>
        </Form>

        <Row hidden={this.state.dirty} className="actions">
          <Column>
            <a className="btn right" onClick={this._handleModalClose}>
              Back
            </a>
          </Column>
        </Row>
      </Modal>
    )
  },
})
