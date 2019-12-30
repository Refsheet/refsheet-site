@Input = React.createClass
  propTypes:
    name: React.PropTypes.string
    id: React.PropTypes.string
    onChange: React.PropTypes.func
    type: React.PropTypes.string
    placeholder: React.PropTypes.string
    label: React.PropTypes.string
    disabled: React.PropTypes.bool
    selected: React.PropTypes.bool
    readOnly: React.PropTypes.bool
    autoFocus: React.PropTypes.bool
    className: React.PropTypes.string
    modelName: React.PropTypes.string
    default: React.PropTypes.string
    browserDefault: React.PropTypes.bool
    focusSelectAll: React.PropTypes.bool
    icon: React.PropTypes.string
    onSubmit: React.PropTypes.func

    value: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.bool
    ])

    error: React.PropTypes.oneOfType([
      React.PropTypes.string
      React.PropTypes.array
    ])

  getInitialState: ->
    value: if @props.type == 'radio' then ('') else (@props.value || @props.default)
    error: @props.error
    dirty: false


  componentWillReceiveProps: (newProps) ->
    if newProps.value != @state.value
      @setState value: (newProps.value || newProps.default)

    if newProps.error != @state.error
      @setState error: newProps.error

  componentDidMount: ->
    if @props.type == 'textarea'
      Materialize.textareaAutoResize(@refs.input)

    if @props.type == 'color'
      tcp =
        $(@refs.input).colorPicker
          doRender: false
          renderCallback: (e, toggle) =>
            if typeof toggle == 'undefined' && e.text
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

  componentDidUpdate: (newProps, newState) ->
    if @props.type == 'textarea' and @props.browserDefault and @state.value != newState.value
      $(@refs.input).css height: 0
      $(@refs.input).css height: @refs.input.scrollHeight + 10

    if @props.type == 'textarea' and !@props.browserDefault
      Materialize.textareaAutoResize(@refs.input)


  _handleInputChange: (e) ->
    if @props.type == 'checkbox'
      value = e.target.checked
    else if @props.type == 'radio'
      value = @props.default if e.target.checked
    else
      value = e.target.value

    @setState error: null, value: value, dirty: true
    @props.onChange(@props.name, value) if @props.onChange

  _handleKeyPress: (e) ->
    switch
      when e.ctrlKey && e.keyCode == 13
        @props.onSubmit() if @props.onSubmit


  render: ->
    className  = @props.className
    className += ' invalid' if @props.error?
    className += ' browser-default' if @props.browserDefault
    className += ' autofocus' if @props.autoFocus
    className += ' margin-bottom--none' if @props.noMargin

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
      noValidate: true


    if @props.type == 'textarea'
      unless @props.browserDefault
        className += ' materialize-textarea'

      inputField =
        `<textarea {...commonProps}
                   value={ this.state.value || '' }
                   onKeyDown={ this._handleKeyPress }
                   className={ className }
        />`

    else if @props.type == 'checkbox'
      inputField =
        `<input {...commonProps}
                type={ this.props.type }
                checked={ this.state.value || false }
        />`

    else if @props.type == 'radio'
      inputField =
        `<input {...commonProps}
                value={ this.props.default }
                type={ this.props.type }
                checked={ this.state.value == this.props.default }
        />`

    else if @props.type == 'color'
      inputField =
        `<input {...commonProps}
                value={ this.state.value || '#000000' }
                type='text'
        />`

      if @props.icon != ''
        icon =
          `<i className='material-icons prefix shadow' style={{ color: this.state.value }}>{ this.props.icon || 'palette' }</i>`

    else
      inputField =
        `<input {...commonProps}
                type={ this.props.type || 'text' }
                value={ this.state.value || '' }
        />`

    if @props.icon
      icon =
        `<i className='material-icons prefix'>{ this.props.icon }</i>`

    wrapperClassNames = ['input-field']
    wrapperClassNames.push 'margin-top--none' if @props.noMargin or !@props.label

    `<div className={ wrapperClassNames.join(' ') }>
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
