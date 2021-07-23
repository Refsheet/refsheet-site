import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Materialize from 'materialize-css'
import Input from './Input'
import $ from 'jquery'
import ObjectPath from '../../utils/ObjectPath'
import Flash from '../../../utils/Flash'
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
    extraData: PropTypes.object,
    onChange: PropTypes.func,
    onError: PropTypes.func,
    errors: PropTypes.object,
    className: PropTypes.string,
    changeEvent: PropTypes.string,
    resetOnSubmit: PropTypes.bool,
    formName: PropTypes.string,
  },

  getInitialState() {
    return {
      model: { ...this.props.model },
      errors: this.props.errors || {},
      dirty: false,
      submitting: false,
      invalid: Object.keys(this.props.errors || {}).length,
    }
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.model !== this.props.model) {
      return this.setState({
        model: { ...newProps.model },
        errors: newProps.errors || {},
        submitting: false,
        dirty: false,
      })
    }
  },

  reload() {
    return this.setState({
      model: { ...this.props.model },
      errors: this.props.errors || {},
      submitting: false,
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
    this.setState({
      model: { ...this.props.model },
      dirty: false,
      submitting: false,
    })
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
    return this.setState({ model: { ...data }, dirty }, () => {
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
    const newModel = { ...this.state.model }
    newModel[name] = value
    const errors = { ...this.state.errors }
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
    if (e != null) {
      e.preventDefault()
    }

    if (this.state.submitting) {
      Flash.error(
        'Another form submission is in progress, please wait a little bit longer...'
      )
      return false
    }

    const data = {}
    ObjectPath.set(data, this.props.modelName, {
      ...this.state.model,
      ...(this.props.extraData || {}),
    })

    this.setState({ submitting: true })
    const _this = this

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
            html: data.responseJSON.error || 'Unknown Error',
            displayLength: 3000,
            classes: 'red',
          })
        } else {
          return Materialize.toast({
            html: data.responseText || 'Unknown Error',
            displayLength: 3000,
            classes: 'red',
          })
        }
      },

      complete: () => {
        _this.setState({ submitting: false })
      },
    })
  },

  _processChildren(children) {
    return React.Children.map(children, child => {
      let childProps = {}

      if (!React.isValidElement(child)) {
        return child
      }

      if (child.type.displayName === 'Input') {
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
            formName: this.props.formName,
            disabled: this.state.submitting || child.props.disabled,
          }
        } else {
          childProps = { key: child.props.id }
        }
      }

      if (
        child.type.displayName === 'Submit' ||
        child.type.displayName === 'Button'
      ) {
        childProps = {
          disabled: this.state.submitting || child.props.disabled,
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
        {this.state.errors.base && (
          <ul className={'errors red-text'}>
            {this.state.errors.base.map((e, i) => (
              <li key={i}>{e}</li>
            ))}
          </ul>
        )}
        {children}
      </form>
    )
  },
})
