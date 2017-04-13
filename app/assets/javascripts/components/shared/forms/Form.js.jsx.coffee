@Form = React.createClass
  propTypes:
    action: React.PropTypes.string.isRequired
    method: React.PropTypes.string
    modelName: React.PropTypes.string.isRequired
    model: React.PropTypes.object.isRequired
    onChange: React.PropTypes.func
    onError: React.PropTypes.func
    errors: React.PropTypes.object
    className: React.PropTypes.string


  getInitialState: ->
    model: @props.model
    errors: @props.errors || {}
    dirty: false

  componentWillReceiveProps: (newProps) ->
    if newProps.model != @state.model
      @setState model: newProps.model, errors: (newProps.errors || {}), dirty: false


  componentDidMount: ->
    Materialize.initializeForms()
    Materialize.updateTextFields()

  componentDidUpdate: ->
    Materialize.updateTextFields()


  _handleInputChange: (name, value) ->
    newModel = @state.model
    newModel[name] = value
    errors = @state.errors
    errors[name] = null
    @setState model: newModel, dirty: true, errors: errors


  _handleFormSubmit: (e) ->
    $(document).trigger 'app:loading'

    data = {}
    data[@props.modelName] = @state.model

    console.debug "Form submit: ", (@props.method || 'POST'), @props.action, data

    $.ajax
      url: @props.action
      type: @props.method || 'POST'
      data: data
      success: (data) =>
        @setState dirty: false, errors: {}
        @props.onChange(data) if @props.onChange

      error: (data) =>
        @props.onError(data) if @props.onError

        if data.responseJSON?.errors
          @setState errors: data.responseJSON.errors
        else if data.responseJSON?.error
          Materialize.toast data.responseJSON.error, 3000, 'red'
        else
          Materialize.toast data.responseText, 3000, 'red'

      complete: ->
        $(document).trigger 'app:loading:done'

    e.preventDefault()


  _processChildren: (children) ->
    React.Children.map children, (child) =>
      childProps = {}

      unless React.isValidElement(child)
        return child

      if child.type == Input
        childProps =
          key: child.props.name
          value: @state.model[child.props.name]
          error: @state.errors[child.props.name]
          onChange: @_handleInputChange
          modelName: @props.modelName

      if child.props.children
        childProps.children = @_processChildren(child.props.children)

      React.cloneElement child, childProps

  render: ->
    children = @_processChildren(@props.children)

    `<form onSubmit={ this._handleFormSubmit }
           className={ this.props.className }>
        { children }
    </form>`
