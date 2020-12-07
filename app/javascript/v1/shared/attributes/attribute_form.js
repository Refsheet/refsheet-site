import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Materialize from 'materialize-css'
import Input from '../forms/Input'
import $ from 'jquery'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let AttributeForm
export default AttributeForm = createReactClass({
  getInitialState() {
    return {
      name: this.props.name,
      value: this.props.value,
      notes: this.props.notes,
      errors: {},
    }
  },

  commit(e) {
    this.props.onCommit(
      {
        id: this.props.id,
        name: this.state.name,
        value: this.state.value,
        notes: this.state.notes,
      },
      () => {
        if (this.props.onCancel != null) {
          return this.props.onCancel()
        } else {
          this.setState({ errors: {} })
          if (this.props.id == null) {
            return this.setState({ name: '', value: '', notes: '' })
          }
        }
      },
      data => {
        console.log(data)
        return this.setState({ errors: data })
      }
    )

    return e.preventDefault()
  },

  handleChange(key, value) {
    const o = {}
    o[key] = value
    return this.setState(o)
  },

  colorPicker(e) {
    return this.setState({ value: e.target.value })
  },

  colorPickerClick(e) {
    return $(e.target).children('input').click()
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    const state = []
    if (newProps.name != null) {
      state.name = newProps.name
    }
    if (newProps.value != null) {
      state.value = newProps.value
    }
    if (newProps.notes != null) {
      state.notes = newProps.notes
    }
    return this.setState(state)
  },

  UNSAFE_componentWillUpdate() {
    if (Materialize.updateTextFields != null) {
      return Materialize.updateTextFields()
    }
  },

  componentDidMount() {
    return $('[name="value"]').focus()
  },

  render() {
    let cancel, iconTag, nameTag, notesTag, saveClassName
    if (this.props.onCancel != null) {
      cancel = (
        <a className="" onClick={this.props.onCancel}>
          <i className="material-icons">cancel</i>
        </a>
      )
    }

    let className = 'attribute-form'

    if (Object.keys(this.state.errors).length !== 0) {
      saveClassName = 'red-text'
    } else {
      saveClassName = 'teal-text'
    }

    if (this.props.inactive) {
      className += ' inactive'
    }

    if (!this.props.hideIcon) {
      iconTag = (
        <div className="icon">
          <i className="material-icons">edit</i>
        </div>
      )
    }

    if (this.props.freezeName) {
      nameTag = <div className="key">{this.state.name}</div>
    } else {
      nameTag = (
        <div className="key">
          <Input
            type="text"
            name="name"
            placeholder="Name"
            error={this.state.errors.name}
            onChange={this.handleChange}
            value={this.state.name}
          />
        </div>
      )
    }

    if (!this.props.hideNotes) {
      notesTag = (
        <div className="notes">
          <Input
            type="text"
            name="notes"
            placeholder="Notes"
            error={this.state.errors.notes}
            onChange={this.handleChange}
            value={this.state.notes}
          />
        </div>
      )
    }

    return (
      <li className={className} data-attribute-id={this.props.id}>
        <form onSubmit={this.commit}>
          {iconTag}

          <div className="attribute-data">
            {nameTag}

            <div className="value">
              <Input
                type={this.props.valueType || 'text'}
                name="value"
                onChange={this.handleChange}
                error={this.state.errors.value}
                value={this.state.value}
              />
            </div>

            {notesTag}
          </div>

          <div className="actions">
            <a className={saveClassName} onClick={this.commit} href="#">
              <i className="material-icons">save</i>
            </a>

            {cancel}
          </div>
        </form>
      </li>
    )
  },
})
