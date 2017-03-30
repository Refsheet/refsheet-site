@Input = React.createClass
  propTypes:
    name: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func
    type: React.PropTypes.string
    placeholder: React.PropTypes.string
    label: React.PropTypes.string
    disabled: React.PropTypes.bool
    readOnly: React.PropTypes.bool
    autoFocus: React.PropTypes.bool
    className: React.PropTypes.string
    value: React.PropTypes.string

    error: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])


  getInitialState: ->
    value: @props.value
    error: @props.error
    dirty: false


  componentWillReceiveProps: (newProps) ->
    if newProps.value != @props.value
      @setState value: newProps.value


  _handleInputChange: (e) ->
    @props.onChange(@props.name, e.target.value) if @props.onChange
    @setState value: e.target.value, dirty: true


  render: ->
    className  = @props.className
    className += ' invalid' if @props.error?

    error = @props.error
    error = error[0] if error?.length

    if @props.type == 'textarea'
      inputField =
        `<textarea id={ this.props.name }
                   name={ this.props.name }
                   disabled={ this.props.disabled }
                   readOnly={ this.props.readOnly }
                   placeholder={ this.props.placeholder }
                   autoFocus={ this.props.autoFocus }
                   onChange={ this._handleInputChange }
                   value={ this.props.value || '' }
                   className={ className + ' materialize-textarea' } />`

    else
      inputField =
        `<input type={ this.props.type || 'text' }
                id={ this.props.name }
                name={ this.props.name }
                className={ className }
                disabled={ this.props.disabled }
                readOnly={ this.props.readOnly }
                placeholder={ this.props.placeholder }
                autoFocus={ this.props.autoFocus }
                onChange={ this._handleInputChange }
                value={ this.state.value || '' } />`

    `<div className='input-field'>
        { inputField }

        { this.props.label &&
            <label htmlFor={ this.props.name }>
                { this.props.label }
            </label> }

        { error &&
            <div className='error-block'>
                { error }
            </div> }

        { !error && this.props.hint &&
            <div className='hint-block'>
                { this.props.hint }
            </div> }
    </div>`
