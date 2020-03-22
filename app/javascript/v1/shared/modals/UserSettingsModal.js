import React from 'react'
import createReactClass from 'create-react-class'
import Modal from 'v1/shared/Modal'
import AttributeTable from 'v1/shared/attributes/attribute_table'
import Attribute from 'v1/shared/attributes/attribute'
import $ from 'jquery'
import * as Materialize from 'materialize-css'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let UserSettingsModal
export default UserSettingsModal = createReactClass({
  getInitialState() {
    return { user: this.props.user }
  },

  handleSettingsClose(e) {
    return Materialize.Modal.getInstance(
      document.getElementById('user-settings-modal')
    ).close()
  },

  handleSettingsChange(setting, onSuccess, onError) {
    const o = {}
    o[setting.id] = setting.value

    return $.ajax({
      url: this.state.user.path,
      type: 'PATCH',
      data: { user: o },
      success: data => {
        this.setState({ user: data })
        if (onSuccess != null) {
          return onSuccess({ value: data[setting.id] })
        }
      },
      error: error => {
        if (onError != null) {
          return onError({
            value:
              error.responseJSON != null
                ? error.responseJSON.errors[setting.id]
                : undefined,
          })
        }
      },
    })
  },

  render() {
    return (
      <Modal id="user-settings-modal">
        <div className="card-panel margin-bottom--large green darken-1 white-text">
          <div className="strong">Notice!</div>
          This window will be going away soon! Please use the Settings link in
          the left menu of your user dashboard to change your account settings.
        </div>

        <h2>User Settings</h2>
        <p>Be sure to save each row individually.</p>

        <AttributeTable
          onAttributeUpdate={this.handleSettingsChange}
          freezeName
          hideNotesForm
        >
          <Attribute
            id="name"
            name="Display Name"
            value={this.state.user.name}
          />
          <Attribute
            id="email"
            name="Email Address"
            value={this.state.user.email}
          />
        </AttributeTable>

        <h3>Danja Zone!</h3>
        <p>Changing these values can break links you've posted elsewhere!</p>
        <AttributeTable
          onAttributeUpdate={this.handleSettingsChange}
          freezeName
          hideNotesForm
        >
          <Attribute
            id="username"
            name="Username"
            value={this.state.user.username}
          />
        </AttributeTable>

        <div className="actions margin-top--large">
          <a className="btn" onClick={this.handleSettingsClose}>
            Close
          </a>
        </div>
      </Modal>
    )
  },
})
