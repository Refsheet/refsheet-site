import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import AttributeForm from './attribute_form'
import Attribute from './attribute'

import $ from 'jquery'
import 'jquery-ui/ui/widgets/sortable'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let AttributeTable
export default AttributeTable = createReactClass({
  getInitialState() {
    return {
      activeEditor: this.props.activeEditor,
      appendMode: false,
    }
  },

  clearEditor() {
    return this.setState({ activeEditor: null })
  },

  componentDidMount() {
    if (this.props.onAttributeUpdate != null) {
      return $(this.refs.table).sortable({
        items: 'li:not(.attribute-form)',
        placeholder: 'drop-target',
        forcePlaceholderSize: true,
        stop: (_, el) => {
          const $item = $(el.item[0])
          const position = $item.parent().children().index($item)

          return this.props.onAttributeUpdate({
            id: $item.data('attribute-id'),
            rowOrderPosition: position,
          })
        },
      })
    }
  },

  _triggerAppend(e) {
    this.setState({ appendMode: true })
    return e.preventDefault()
  },

  render() {
    let newForm
    const children = React.Children.map(this.props.children, child => {
      if (this.props.hideEmpty && !child.props.value) {
        return
      }

      if (!child || !child.type || child.type.displayName !== 'Attribute') {
        return child
      }

      return React.cloneElement(child, {
        onCommit: this.props.onAttributeUpdate,
        onDelete: this.props.onAttributeDelete,
        editorActive: this.state.activeEditor === child.key,
        sortable: this.props.sortable,
        valueType: this.props.valueType,
        defaultValue: this.props.defaultValue,
        freezeName: this.props.freezeName,
        hideNotesForm: this.props.hideNotesForm,

        onEditStart: () => {
          return this.setState({ activeEditor: child.key, appendMode: false })
        },

        onEditStop: () => {
          return this.setState({ activeEditor: null })
        },
      })
    })

    if (this.props.onAttributeCreate != null) {
      if (this.state.appendMode) {
        newForm = (
          <AttributeForm
            onCommit={this.props.onAttributeCreate}
            inactive={this.state.activeEditor != null}
            hideNotes={this.props.hideNotesForm}
            hideIcon={this.props.hideIcon}
            valueType={this.props.valueType}
            onFocus={this.clearEditor}
          />
        )
      } else {
        newForm = (
          <li className="attribute-form">
            <div className="full-row">
              <a href="#" onClick={this._triggerAppend} className="block">
                <i className="material-icons">add</i>
              </a>
            </div>
          </li>
        )
      }
    }

    let className = 'attribute-table'
    if (this.props.sortable) {
      className += ' sortable'
    }
    if (this.props.className) {
      className += ' ' + this.props.className
    }

    return (
      <ul className={className} ref="table">
        {children}
        {newForm}
      </ul>
    )
  },
})
