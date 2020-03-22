import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Materialize from 'materialize-css'
import Input from './Input'
import $ from 'jquery'
import ObjectPath from '../../utils/ObjectPath'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Form
export default Form = createReactClass({
  propTypes: {
    action: PropTypes.string.isRequired,
    method: PropTypes.string,
    modelName: PropTypes.string.isRequired,
    model: PropTypes.object.isRequired,
    onChange: PropTypes.func,
    onError: PropTypes.func,
    errors: PropTypes.object,
    className: PropTypes.string,
    changeEvent: PropTypes.string,
    resetOnSubmit: PropTypes.bool,
  },

  getInitialState() {
    return {
      model: $.extend({}, this.props.model),
      errors: this.props.errors || {},
      dirty: false,
      invalid: Object.keys(this.props.errors || {}).length,
    }
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.model !== this.props.model) {
      return this.setState({
        model: $.extend({}, newProps.model),
        errors: newProps.errors || {},
        dirty: false,
      })
    }
  },

  reload() {
    return this.setState({
      model: $.extend({}, this.props.model),
      errors: this.props.errors || {},
      dirty: false,
    })
  },

  componentDidMount() {
    return Materialize.updateTextFields()
  },

  componentDidUpdate() {
    return Materialize.updateTextFields()
  },

  reset() {
    this.setState({ model: $.extend({}, this.props.model), dirty: false })
    if (this.props.onDirty) {
      return this.props.onDirty(false)
    }
  },

  submit() {
    return this._handleFormSubmit()
  },

  setModel(data, dirty, callback = null) {
    if (dirty == null) {
      dirty = true
    }
    return this.setState({ model: $.extend({}, data), dirty }, () => {
      if (this.props.onDirty) {
        this.props.onDirty(dirty)
      }
      if (this.props.onUpdate) {
        this.props.onUpdate(data)
      }
      if (callback) {
        return callback()
      }
    })
  },

  _handleInputChange(name, value) {
    const newModel = $.extend({}, this.state.model)
    newModel[name] = value
    const errors = $.extend({}, this.state.errors)
    errors[name] = undefined
    let dirty = false
    let invalid = false

    for (let k in newModel) {
      const v = newModel[k]
      const o = this.props.model[k]
      if (errors[k]) {
        invalid = true
      }

      if (v !== o && !(v === false && typeof o === 'undefined')) {
        dirty = true
      }
    }

    this.setState({ model: newModel, dirty, invalid, errors })
    if (this.props.onUpdate) {
      this.props.onUpdate(newModel)
    }
    if (this.props.onDirty) {
      return this.props.onDirty(dirty)
    }
  },

  _handleFormSubmit(e) {
    $(document).trigger('app:loading')

    const data = {}
    ObjectPath.set(data, this.props.modelName, this.state.model)

    $.ajax({
      url: this.props.action,
      type: this.props.method || 'POST',
      data,
      dataType: 'json',
      success: data => {
        this.setState({ dirty: false, errors: {} })
        if (this.props.onChange) {
          this.props.onChange(data)
        }
        if (this.props.onDirty) {
          this.props.onDirty(false)
        }
        if (this.props.resetOnSubmit) {
          this.reset()
        }
        if (this.props.changeEvent) {
          $(document).trigger(this.props.changeEvent, data)
        }
        return console.log('Complete:', data)
      },

      error: data => {
        if (this.props.onError) {
          this.props.onError(data)
        }
        console.log('Error:', data)

        if (data.responseJSON != null ? data.responseJSON.errors : undefined) {
          console.warn('Error messages:', data.responseJSON.errors)
          return this.setState({
            errors: data.responseJSON.errors,
            invalid: true,
          })
        } else if (
          data.responseJSON != null ? data.responseJSON.error : undefined
        ) {
          return Materialize.toast({
            html: data.responseJSON.error,
            displayLength: 3000,
            classes: 'red',
          })
        } else {
          return Materialize.toast({
            html: data.responseText,
            displayLength: 3000,
            classes: 'red',
          })
        }
      },

      complete() {
        return $(document).trigger('app:loading:done')
      },
    })

    if (e != null) {
      return e.preventDefault()
    }
  },

  _processChildren(children) {
    return React.Children.map(children, child => {
      let childProps = {}

      if (!React.isValidElement(child)) {
        return child
      }

      if (child.type === Input) {
        if (child.props.name) {
          const errorKey = child.props.errorPath
            ? child.props.errorPath + '.' + child.props.name
            : child.props.name
          const value = this.state.model[child.props.name]
          childProps = {
            key: child.props.name,
            value,
            error: this.state.errors[errorKey],
            onChange: this._handleInputChange,
            onSubmit: this._handleFormSubmit,
            modelName: this.props.modelName,
          }
        } else {
          childProps = { key: child.props.id }
        }
      }

      if (child.props.children) {
        childProps.children = this._processChildren(child.props.children)
      }

      return React.cloneElement(child, childProps)
    })
  },

  render() {
    const children = this._processChildren(this.props.children)

    const classNames = []
    classNames.push(this.props.className)
    if (this.state.invalid) {
      classNames.push('has-errors')
    }

    return (
      <form
        onSubmit={this._handleFormSubmit}
        className={classNames.join(' ')}
        action={this.props.action}
        method={this.props.method}
        noValidate
      >
        {children}
      </form>
    )
  },
})
