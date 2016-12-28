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

  render: ->
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
      />`

    else
      `<li data-attribute-id={ this.props.id }>
          { icon }

          <div className='key'>{ this.props.name }</div>
          <div className='value'>{ this.props.value }</div>
          <div className='notes'>{ this.props.notes }</div>

          <div className='actions'>
              { edit }
              { trash }
          </div>
      </li>`
