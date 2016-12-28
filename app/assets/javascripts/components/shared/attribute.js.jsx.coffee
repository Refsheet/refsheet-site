@Attribute = React.createClass
  getInitialState: ->
    color: @props.color
    notes: @props.notes
    name: @props.name
    value: @props.value

  deleteAttribute: (e) ->
    @props.onDelete(@props.guid)
    e.preventDefault()

  startEdit: (e) ->
    e.preventDefault()

  commit: (e) ->
    @props.onChange(@props.guid, @state)
    e.preventDefault()

  render: ->
    if @state.color?
      color =
        `<div className='icon'>
            <i className='material-icons' style={{color: this.state.color}}>palette</i>
        </div>`

    if @state.notes?
      notes =
        `<div className='notes right muted smaller'>{ this.state.notes }</div>`

    if @props.onChange?
      edit =
        `<div className='edit' onClick={ this.startEdit }>
            <i className='material-icons'>edit</i>
        </div>`

    if @props.onDelete?
      trash =
        `<div className='delete' onClick={ this.deleteAttribute }>
            <i className='material-icons'>delete</i>
        </div>`

    `<li>
        { color }
        <div className='key'>{ this.state.name }</div>
        <div className='value'> { this.state.value }{ notes }</div>
        { edit }
        { trash }
    </li>`
