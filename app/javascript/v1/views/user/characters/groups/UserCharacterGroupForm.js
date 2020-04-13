/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Form from '../../../../shared/forms/Form'
import Input from '../../../../shared/forms/Input'
import Submit from '../../../../shared/forms/Submit'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
//@User.CharacterGroups.Form = createReactClass
let UserCharacterGroupForm
export default UserCharacterGroupForm = createReactClass({
  propTypes: {
    group: PropTypes.object,
    onChange: PropTypes.func,
  },

  getInitialState() {
    return {
      model: {
        name:
          (this.props.group != null ? this.props.group.name : undefined) || '',
      },
    }
  },

  render() {
    let action, icon, method
    const editing = !!this.props.group

    if (editing) {
      method = 'PUT'
      action = this.props.group.path
      icon = 'edit'
    } else {
      method = 'POST'
      action = '/character_groups'
      icon = 'create_new_folder'
    }

    return (
      <li className="form fixed">
        <Form
          action={action}
          model={this.state.model}
          className="inline"
          modelName="character_group"
          onChange={this.props.onChange}
          resetOnSubmit
          method={method}
        >
          <i className="material-icons left folder">{icon}</i>

          <Input
            type="text"
            placeholder={editing ? 'Edit Group' : 'New Group'}
            autoFocus={editing}
            name="name"
          />

          <Submit link noWaves>
            <i className="material-icons">save</i>
          </Submit>
        </Form>
      </li>
    )
  },
})
