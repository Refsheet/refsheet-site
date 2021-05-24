import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import $ from 'jquery'
import c from 'classnames'
import validate, {
  errorString,
  isHexColor,
  isColor,
} from '../../../utils/validate'
import ColorPicker from '../../../components/Shared/ColorPicker'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Input
export default Input = createReactClass({
  propTypes: {
    name: PropTypes.string,
    id: PropTypes.string,
    onChange: PropTypes.func,
    type: PropTypes.string,
    /**
     * Use to allow only hexadecimal color codes. type === 'color' required.
     */
    hexOnly: PropTypes.bool,
    placeholder: PropTypes.string,
    label: PropTypes.string,
    disabled: PropTypes.bool,
    selected: PropTypes.bool,
    readOnly: PropTypes.bool,
    autoFocus: PropTypes.bool,
    className: PropTypes.string,
    modelName: PropTypes.string,
    formName: PropTypes.string,
    default: PropTypes.string,
    browserDefault: PropTypes.bool,
    focusSelectAll: PropTypes.bool,
    icon: PropTypes.string,
    onSubmit: PropTypes.func,
    autoGrow: PropTypes.bool,

    value: PropTypes.oneOfType([PropTypes.string, PropTypes.bool]),

    error: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
  },

  getInitialState() {
    return {
      value:
        this.props.type === 'radio'
          ? ''
          : this.props.value || this.props.default,
      error: this.props.error,
      validationErrors: [],
      dirty: false,
      showColorPicker: false,
    }
  },

  componentDidMount() {
    if (this.props.type === 'textarea') {
      Materialize.textareaAutoResize(this.inputRef)
    }
  },

  handleFocus(e) {
    clearTimeout(this._blurTimeout)
    this.inputRef && this.inputRef.focus()

    if (this.props.focusSelectAll) {
      this.inputRef && this.inputRef.select()
    }

    if (this.props.type === 'color') {
      this.setState({ showColorPicker: true })
    }
  },

  handleBlur(e) {
    this._blurTimeout = setTimeout(() => {
      if (this.props.type === 'color') {
        this.setState({ showColorPicker: false })
      }
      // A timeout of 0 might be a problem here. If we see issues where the color picker keeps closing when you click it,
      // this might need to be increased. System specs play a role here.
    }, 0)
  },

  componentDidUpdate(prevProps, prevState) {
    if (
      this.props.type === 'textarea' &&
      this.props.browserDefault &&
      this.state.value !== prevState.value
    ) {
      const overflow = this.inputRef.style.overflow
      this.inputRef.style.overflow = 'hidden'
      this.inputRef.style.height = '5px'
      this.inputRef.style.height = this.inputRef.scrollHeight + 'px'
      this.inputRef.style.overflow = overflow
      console.log(this.inputRef, this.inputRef.style.height)
    }

    if (this.props.type === 'textarea' && !this.props.browserDefault) {
      // TODO: Is this Return correct?
      return Materialize.textareaAutoResize(this.inputRef)
    }

    if (prevProps.value !== this.props.value) {
      this.setState({ value: this.props.value || this.props.default })
    }

    if (prevProps.error !== this.props.error) {
      return this.setState({ error: this.props.error })
    }
  },

  handleColorClose() {
    this.setState({ showColorPicker: false })
  },

  handleColorChange(data) {
    this._handleInputChange({
      target: {
        value: data.hex,
      },
    })
  },

  _handleInputChange(e) {
    let value
    if (this.props.type === 'checkbox') {
      value = e.target.checked
    } else if (this.props.type === 'radio') {
      if (e.target.checked) {
        value = this.props.default
      }
    } else {
      value = e.target.value
    }

    let model = {}
    model[this.props.name] = value

    let validations = []

    // Assign validators here.
    if (this.props.type === 'color') {
      if (this.props.hexOnly) {
        validations.push(isHexColor)
        value = isHexColor.transform(value)
      } else {
        validations.push(isColor)
      }
    }

    let validators = {}
    validators[this.props.name] = validations
    const errors = validate(model, validators)[this.props.name]

    this.setState({ error: null, validationErrors: errors, value, dirty: true })
    if (this.props.onChange) {
      return this.props.onChange(this.props.name, value)
    }
  },

  _handleKeyPress(e) {
    switch (false) {
      case !e.ctrlKey || e.keyCode !== 13:
        if (this.props.onSubmit) {
          return this.props.onSubmit()
        }
        break
    }
  },

  render() {
    let icon, id, inputField
    let { className } = this.props
    const { showColorPicker } = this.state

    let errors = this.state.validationErrors || []
    let error
    if (this.state.error) {
      if (this.state.error.map) {
        errors = [...errors, ...this.state.error]
      } else {
        errors = [...errors, this.state.error]
      }
    }

    if (errors.length > 0) {
      className += ' invalid'
      error = errorString(errors)
    }
    if (this.props.browserDefault) {
      className += ' browser-default'
    }
    if (this.props.autoFocus) {
      className += ' autofocus'
    }
    if (this.props.noMargin) {
      className += ' margin-bottom--none'
    }

    let inputFieldInsideLabel = false

    if (this.props.id) {
      ;({ id } = this.props)
    } else if (this.props.modelName) {
      id = `${this.props.modelName}_${this.props.name}`
    } else {
      id = this.props.name
    }

    if (this.props.formName) {
      id = this.props.formName + '_' + id
    }

    const commonProps = {
      id,
      name: this.props.name,
      ref: r => (this.inputRef = r),
      disabled: this.props.disabled,
      readOnly: this.props.readOnly,
      placeholder: this.props.placeholder,
      autoFocus: this.props.autoFocus,
      onChange: this._handleInputChange,
      className,
      noValidate: true,
    }

    if (this.props.type === 'textarea') {
      if (!this.props.browserDefault) {
        className += ' materialize-textarea'
      }

      inputField = (
        <textarea
          {...commonProps}
          value={this.state.value || ''}
          onKeyDown={this._handleKeyPress}
          className={className}
        />
      )
    } else if (this.props.type === 'checkbox') {
      inputFieldInsideLabel = true
      inputField = (
        <input
          {...commonProps}
          type={this.props.type}
          checked={this.state.value || false}
        />
      )
    } else if (this.props.type === 'radio') {
      inputFieldInsideLabel = true
      inputField = (
        <input
          {...commonProps}
          value={this.props.default}
          type={this.props.type}
          checked={this.state.value === this.props.default}
        />
      )
    } else if (this.props.type === 'color') {
      inputField = (
        <input {...commonProps} value={this.state.value || ''} type="text" />
      )

      if (this.props.icon !== '') {
        let iconName = this.props.icon || 'palette'
        let color = this.state.value

        if (error) {
          iconName = 'error'
          color = 'inherit'
        }

        icon = (
          <i
            className="material-icons prefix shadow"
            style={{ color }}
            onClick={this.handleFocus}
          >
            {iconName}
          </i>
        )
      }
    } else {
      inputField = (
        <input
          {...commonProps}
          type={this.props.type || 'text'}
          value={this.state.value || ''}
        />
      )
    }

    if (this.props.icon) {
      icon = (
        <i className="material-icons prefix" onClick={this.handleFocus}>
          {this.props.icon}
        </i>
      )
    }

    const wrapperClassNames = []
    if (this.props.type !== 'radio' && this.props.type !== 'checkbox') {
      wrapperClassNames.push('input-field')
    }
    if (this.props.noMargin || !this.props.label) {
      wrapperClassNames.push('margin-top--none')
    }
    if (this.props.type === 'radio' || this.props.type === 'checkbox') {
      wrapperClassNames.push('check-field')
    }

    return (
      <div
        className={wrapperClassNames.join(' ')}
        onFocus={this.handleFocus}
        onBlur={this.handleBlur}
      >
        {icon}
        {!inputFieldInsideLabel && inputField}

        {this.props.label && (
          <label
            htmlFor={id}
            className={c({
              active:
                this.state.value ||
                commonProps.placeholder ||
                commonProps.default,
            })}
          >
            {inputFieldInsideLabel && inputField}
            <span>{this.props.label}</span>
          </label>
        )}

        {error && <div className="error-block">{error}</div>}

        {!error && this.props.hint && (
          <div className="hint-block">{this.props.hint}</div>
        )}

        {showColorPicker && (
          <ColorPicker
            overlay
            color={this.state.value}
            colors={this.props.colors}
            onClose={this.handleColorClose}
            onFocus={this.handleFocus}
            onChangeComplete={this.handleColorChange}
          />
        )}
      </div>
    )
  },
})
