import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Modal from 'v1/shared/Modal'
import Form from 'v1/shared/forms/Form'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'
import Input from 'v1/shared/forms/Input'
import Submit from 'v1/shared/forms/Submit'

import $ from 'jquery'
import * as Materialize from 'materialize-css'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CharacterSettingsModal
export default CharacterSettingsModal = createReactClass({
  propTypes: {
    character: PropTypes.object.isRequired,
  },

  getInitialState() {
    return { dirty: false }
  },

  _handleSettingsClose(e) {
    const el = document.getElementById('character-settings-form')
    if (el) {
      return Materialize.Modal.getInstance(el).close()
    }
  },

  _handleChange(character) {
    if (character.link !== this.props.character.link) {
      window.history.replaceState({}, '', character.link)
    }

    $(document).trigger('app:character:update', character)

    this._handleSettingsClose()
    return Materialize.toast({
      html: 'Character saved!',
      displayLength: 3000,
      classes: 'green',
    })
  },

  _handleCancel(e) {
    this.refs.form.reset()
    this._handleSettingsClose()
    return e.preventDefault()
  },

  _handleDirty(dirty) {
    return this.setState({ dirty })
  },

  render() {
    return (
      <Modal id="character-settings-form" title="Character Settings">
        <Form
          action={this.props.character.path}
          method="PUT"
          modelName="character"
          model={this.props.character}
          onChange={this._handleChange}
          onDirty={this._handleDirty}
          ref="form"
        >
          <Row noMargin>
            <Column m={6}>
              <Input name="name" label="Name" autoFocus />
            </Column>
            <Column s={6} m={3}>
              <Input name="nsfw" type="checkbox" label="NSFW" />
            </Column>
            <Column s={6} m={3}>
              <Input name="hidden" type="checkbox" label="Hidden" />
            </Column>
          </Row>

          <Row>
            <Column m={6}>
              <Input
                name="slug"
                label={'refsheet.net/' + this.props.character.user_id + '/'}
              />
            </Column>
            <Column m={6}>
              <Input name="shortcode" label="ref.st/" />
            </Column>
          </Row>

          <Row noMargin hidden={this.props.character.pending_transfer}>
            <Column m={6}>
              <a className="red-text modal-trigger" href="#delete-form">
                Delete Character
              </a>
              <div className="muted">This can not be undone!</div>
            </Column>
            <Column m={6}>
              <a href="#character-transfer-modal" className="modal-trigger">
                Transfer Character
              </a>
              <div className="muted">The recipient will have to accept.</div>
            </Column>
          </Row>

          <Row noMargin hidden={!this.props.character.pending_transfer}>
            <Column>
              <p>Transfer Pending</p>
              <div className="muted">
                You cannot delete or initiate a new transfer until the old one
                is finished.
              </div>
            </Column>
          </Row>

          <Row hidden={!this.state.dirty} className="actions">
            <Column>
              <a className="btn btn-secondary" onClick={this._handleCancel}>
                Cancel
              </a>
              <div className="right">
                <Submit>Save</Submit>
              </div>
            </Column>
          </Row>
        </Form>

        <Row hidden={this.state.dirty} className="actions">
          <Column>
            <a className="btn right" onClick={this._handleSettingsClose}>
              Done
            </a>
          </Column>
        </Row>
      </Modal>
    )
  },
})
