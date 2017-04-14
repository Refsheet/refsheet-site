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
    modelName: React.PropTypes.string

    value: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.bool
    ])

    error: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])


  getInitialState: ->
    value: @props.value
    error: @props.error
    dirty: false


  componentWillReceiveProps: (newProps) ->
    if newProps.value != @state.value
      @setState value: newProps.value

    if newProps.error != @state.error
      @setState error: newProps.error


  _handleInputChange: (e) ->
    if @props.type in ['checkbox', 'radio']
      value = e.target.checked
      console.log e.target.checked
    else
      value = e.target.value

    @setState error: null, value: value, dirty: true
    @props.onChange(@props.name, value) if @props.onChange


  render: ->
    className  = @props.className
    className += ' invalid' if @props.error?

    error = @props.error
    error = error[0] if error?.length

    if @props.modelName
      id = "#{@props.modelName}_#{@props.name}"
    else
      id = @props.name

    commonProps =
      id: id
      name: @props.name
      disabled: @props.disabled
      readOnly: @props.readOnly
      placeholder: @props.placeholder
      autoFocus: @props.autoFocus
      onChange: @_handleInputChange
      className: className


    if @props.type == 'textarea'
      inputField =
        `<textarea {...commonProps}
                   value={ this.props.value || '' }
                   className={ className + ' materialize-textarea' } />`

    else if @props.type in ['checkbox', 'radio']
      inputField =
        `<input {...commonProps}
                type={ this.props.type }
                checked={ this.state.value || false } />`
    else
      inputField =
        `<input {...commonProps}
                type={ this.props.type || 'text' }
                value={ this.state.value || '' } />`

    `<div className='input-field'>
        { inputField }

        { this.props.label &&
            <label htmlFor={ id }>
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
