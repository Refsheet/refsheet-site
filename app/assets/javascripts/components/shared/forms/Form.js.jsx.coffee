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
    changeEvent: React.PropTypes.string


  getInitialState: ->
    model: $.extend {}, @props.model
    errors: @props.errors || {}
    dirty: false

  componentWillReceiveProps: (newProps) ->
    if newProps.model != @props.model
      @setState model: $.extend({}, newProps.model), errors: (newProps.errors || {}), dirty: false


  componentDidMount: ->
    Materialize.initializeForms()
    Materialize.updateTextFields()

  componentDidUpdate: ->
    Materialize.updateTextFields()


  reset: ->
    @setState model: $.extend({}, @props.model), dirty: false
    @props.onDirty(false) if @props.onDirty

  submit: ->
    @_handleFormSubmit()

  setModel: (data, dirty=true, callback=null) ->
    @setState { model: $.extend({}, data), dirty: dirty }, =>
      @props.onDirty(dirty) if @props.onDirty
      @props.onUpdate(data) if @props.onUpdate
      callback() if callback


  _handleInputChange: (name, value) ->
    newModel = @state.model
    newModel[name] = value
    errors = @state.errors
    errors[name] = null
    dirty = false

    for k, v of newModel
      o = @props.model[k]

      if v != o and !(v == false and typeof(o) == 'undefined')
        dirty = true

    @setState model: newModel, dirty: dirty, errors: errors
    @props.onUpdate(newModel) if @props.onUpdate
    @props.onDirty(dirty) if @props.onDirty


  _handleFormSubmit: (e) ->
    $(document).trigger 'app:loading'

    data = {}
    ObjectPath.set data, @props.modelName, @state.model

    console.debug "Form submit: ", (@props.method || 'POST'), @props.action, data

    $.ajax
      url: @props.action
      type: @props.method || 'POST'
      data: data
      success: (data) =>
        @setState dirty: false, errors: {}
        @props.onChange(data) if @props.onChange
        @props.onDirty(false) if @props.onDirty
        $(document).trigger @props.changeEvent, data if @props.changeEvent

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

    e.preventDefault() if e?


  _processChildren: (children) ->
    React.Children.map children, (child) =>
      childProps = {}

      unless React.isValidElement(child)
        return child

      if child.type == Input
        if child.props.name
          childProps =
            key: child.props.name
            value: @state.model[child.props.name]
            error: @state.errors[child.props.name]
            onChange: @_handleInputChange
            modelName: @props.modelName
        else
          childProps =
            key: child.props.id

      if child.props.children
        childProps.children = @_processChildren(child.props.children)

      React.cloneElement child, childProps

  render: ->
    children = @_processChildren(@props.children)

    `<form onSubmit={ this._handleFormSubmit }
           className={ this.props.className }>
        { children }
    </form>`
