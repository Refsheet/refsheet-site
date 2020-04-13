import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import AttributeForm from './attribute_form'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Attribute = createReactClass({
  getInitialState() {
    return { edit: this.props.onCommit != null && this.props.editorActive }
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (this.state.edit && newProps.editorActive === false) {
      return this.setState({ edit: false })
    }
  },

  deleteAttribute(e) {
    this.props.onDelete(this.props.id)
    return e.preventDefault()
  },

  startEdit(e) {
    this.setState({ edit: true })
    if (this.props.onEditStart != null) {
      this.props.onEditStart()
    }
    if (e != null) {
      return e.preventDefault()
    }
  },

  cancelEdit(e) {
    this.setState({ edit: false })
    if (this.props.onEditStop != null) {
      this.props.onEditStop()
    }
    if (e != null) {
      return e.preventDefault()
    }
  },

  handleAttributeClick(e) {
    if (this.props.onCommit) {
      return this.startEdit(e)
    }
  },

  render() {
    let defaultValue, edit, icon, trash
    if (this.props.defaultValue != null) {
      defaultValue = (
        <span className="default-value">{this.props.defaultValue}</span>
      )
    }

    if (this.props.icon != null) {
      icon = (
        <div className="icon">
          <i className="material-icons" style={{ color: this.props.iconColor }}>
            {this.props.icon}
          </i>
        </div>
      )
    }

    if (this.props.onDelete != null) {
      trash = (
        <a className="attr-delete" onClick={this.deleteAttribute} href="#">
          <i className="material-icons">delete</i>
        </a>
      )
    }

    if (this.props.onCommit != null) {
      edit = (
        <a className="attr-start-edit" onClick={this.startEdit} href="#">
          <i className="material-icons">edit</i>
        </a>
      )
    }

    if (this.state.edit) {
      return (
        <AttributeForm
          name={this.props.name}
          value={this.props.value}
          notes={this.props.notes}
          id={this.props.id}
          onCancel={this.cancelEdit}
          onCommit={this.props.onCommit}
          valueType={this.props.valueType}
          hideIcon={this.props.icon == null}
          freezeName={this.props.freezeName}
          hideNotes={this.props.hideNotesForm}
        />
      )
    } else {
      let notesTag
      if (!this.props.hideNotesForm) {
        notesTag = (
          <div className="notes" onClick={this.handleAttributeClick}>
            {this.props.notes}
          </div>
        )
      }

      return (
        <li data-attribute-id={this.props.id}>
          {icon}

          <div className="attribute-data">
            <div className="key">{this.props.name}</div>
            <div className="value" onClick={this.handleAttributeClick}>
              {this.props.value || defaultValue}
            </div>
            {notesTag}
          </div>

          <div className="actions">
            {edit}
            {trash}
          </div>
        </li>
      )
    }
  },
})

export default Attribute
