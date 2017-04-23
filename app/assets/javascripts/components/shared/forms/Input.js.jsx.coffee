@Input = React.createClass
  propTypes:
    name: React.PropTypes.string
    id: React.PropTypes.string
    onChange: React.PropTypes.func
    type: React.PropTypes.string
    placeholder: React.PropTypes.string
    label: React.PropTypes.string
    disabled: React.PropTypes.bool
    readOnly: React.PropTypes.bool
    autoFocus: React.PropTypes.bool
    className: React.PropTypes.string
    modelName: React.PropTypes.string
    default: React.PropTypes.string
    browserDefault: React.PropTypes.bool
    focusSelectAll: React.PropTypes.bool

    value: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.bool
    ])

    error: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])


  getInitialState: ->
    value: @props.value || @props.default
    error: @props.error
    dirty: false


  componentWillReceiveProps: (newProps) ->
    if newProps.value != @state.value
      @setState value: (newProps.value || newProps.default)

    if newProps.error != @state.error
      @setState error: newProps.error

  componentDidMount: ->
    if @props.type == 'color'
      tcp =
        $(@refs.input).colorPicker
          doRender: false
          renderCallback: (e, toggle) =>
            if typeof toggle == 'undefined'
              @_handleInputChange target: value: e.text

      window.tcp = tcp

      $(@refs.input)
        .blur ->
          tcp.colorPicker.$UI.hide()

        .focus ->
          tcp.colorPicker.$UI.show()

    if @props.focusSelectAll
      $(@refs.input).focus ->
        $(this).select()


  _handleInputChange: (e) ->
    if @props.type in ['checkbox', 'radio']
      value = e.target.checked
    else
      value = e.target.value

    @setState error: null, value: value, dirty: true
    @props.onChange(@props.name, value) if @props.onChange


  render: ->
    className  = @props.className
    className += ' invalid' if @props.error?
    className += ' browser-default' if @props.browserDefault

    error = @props.error
    error = error[0] if error?.length

    if @props.id
      id = @props.id
    else if @props.modelName
      id = "#{@props.modelName}_#{@props.name}"
    else
      id = @props.name

    commonProps =
      id: id
      name: @props.name
      ref: 'input'
      disabled: @props.disabled
      readOnly: @props.readOnly
      placeholder: @props.placeholder
      autoFocus: @props.autoFocus
      onChange: @_handleInputChange
      className: className


    if @props.type == 'textarea'
      className += ' materialize-textarea' unless @props.browserDefault
      inputField =
        `<textarea {...commonProps}
                   value={ this.state.value || '' }
                   className={ className }
        />`

    else if @props.type in ['checkbox', 'radio']
      inputField =
        `<input {...commonProps}
                type={ this.props.type }
                checked={ this.state.value || false }
        />`

    else if @props.type == 'color'
      inputField =
        `<input {...commonProps}
                value={ this.state.value || '#000000' }
                type='text'
        />`

      icon =
        `<i className='material-icons prefix shadow' style={{ color: this.state.value }}>palette</i>`

    else
      inputField =
        `<input {...commonProps}
                type={ this.props.type || 'text' }
                value={ this.state.value || '' }
        />`

    `<div className='input-field'>
        { icon }
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
