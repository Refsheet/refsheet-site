@AttributeTable = React.createClass
  getInitialState: ->
    activeEditor: @props.activeEditor
    appendMode: false

  clearEditor: ->
    @setState activeEditor: null

  componentDidMount: ->
    if @props.onAttributeUpdate?
      $('.attribute-table.sortable').sortable
        items: 'li:not(.attribute-form)'
        placeholder: 'drop-target'
        forcePlaceholderSize: true
        stop: (_, el) =>
          $item = $(el.item[0])
          position = $item.parent().children().index($item)

          @props.onAttributeUpdate
            id: $item.data 'attribute-id'
            rowOrderPosition: position

  _triggerAppend: (e) ->
    @setState appendMode: true
    e.preventDefault()

  render: ->
    children = React.Children.map @props.children, (child) =>
      return if @props.hideEmpty and not child.props.value
      return child unless child?.type == Attribute

      React.cloneElement child,
        onCommit: @props.onAttributeUpdate
        onDelete: @props.onAttributeDelete
        editorActive: (@state.activeEditor == child.key)
        sortable: @props.sortable
        valueType: @props.valueType
        defaultValue: @props.defaultValue
        freezeName: @props.freezeName
        hideNotesForm: @props.hideNotesForm

        onEditStart: =>
          @setState activeEditor: child.key, appendMode: false
          
        onEditStop: =>
          @setState activeEditor: null

    if @props.onAttributeCreate?
      if @state.appendMode
        newForm =
          `<AttributeForm onCommit={ this.props.onAttributeCreate }
                          inactive={ this.state.activeEditor != null }
                          valueType={ this.props.valueType }
                          onFocus={ this.clearEditor } />`
      else
        newForm =
          `<li className='attribute-form'>
              <div className='full-row'>
                  <a href='#' onClick={ this._triggerAppend } className='block'>
                      <i className='material-icons'>add</i>
                  </a>
              </div>
          </li>`

    className = 'attribute-table'

    if @props.sortable
      className += ' sortable'

    `<ul className={ className }>
        { children }
        { newForm }
    </ul>`
