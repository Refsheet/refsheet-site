@Attribute = React.createClass
  getInitialState: ->
    edit: @props.onCommit? && @props.editorActive

  componentWillReceiveProps: (newProps) ->
    if @state.edit && newProps.editorActive == false
      @setState edit: false

  deleteAttribute: (e) ->
    @props.onDelete(@props.id)
    e.preventDefault()

  startEdit: (e) ->
    @setState edit: true
    @props.onEditStart() if @props.onEditStart?
    e.preventDefault() if e?

  cancelEdit: (e) ->
    @setState edit: false
    @props.onEditStop() if @props.onEditStop?
    e.preventDefault() if e?

  handleAttributeClick: (e) ->
    if @props.onCommit
      @startEdit(e)

  render: ->
    if @props.defaultValue?
      defaultValue =
        `<span className='default-value'>{ this.props.defaultValue }</span>`
      
    if @props.icon?
      icon =
        `<div className='icon'>
            <i className='material-icons' style={{color: this.props.iconColor}}>{ this.props.icon }</i>
        </div>`

    if @props.onDelete?
      trash =
        `<a className='' onClick={ this.deleteAttribute }>
            <i className='material-icons'>delete</i>
        </a>`

    if @props.onCommit?
      edit =
        `<a className='' onClick={ this.startEdit }>
            <i className='material-icons'>edit</i>
        </a>`

    if @state.edit
      `<AttributeForm name={ this.props.name }
                      value={ this.props.value }
                      notes={ this.props.notes }
                      id={ this.props.id }
                      onCancel={ this.cancelEdit }
                      onCommit={ this.props.onCommit }
                      valueType={ this.props.valueType }
                      hideIcon={ this.props.icon == null }
                      freezeName={ this.props.freezeName }
                      hideNotes={ this.props.hideNotesForm }
      />`

    else
      unless @props.hideNotesForm
        notesTag =
          `<div className='notes' onClick={ this.handleAttributeClick }>{ this.props.notes }</div>`

      `<li data-attribute-id={ this.props.id }>
          { icon }

          <div className='attribute-data'>
              <div className='key'>{ this.props.name }</div>
              <div className='value' onClick={ this.handleAttributeClick }>{ this.props.value || defaultValue }</div>
              { notesTag }
          </div>

          <div className='actions'>
              { edit }
              { trash }
          </div>
      </li>`
