@UserCharacterGroupLink = React.createClass
  propTypes: ->
    group: React.PropTypes.object.isRequired
    editable: React.PropTypes.bool
    onChange: React.PropTypes.func

  getInitialState: ->
    edit: false


  _initialize: ->
    $link = $(@refs.link)

    $link.draggable
      revert: true
      opacity: 0.6
      appendTo: 'body'
      cursorAt:
        top: 5
        left: 5

    $link.droppable
      tolerance: 'pointer'
      drop: (event, ui) =>
        $source = ui.draggable
        sourceId = $source.data 'group-id'
        @_handleDrop(sourceId)


  _handleEdit: (e) ->
    @setState edit: true
    e.preventDefault()

  _handleChange: (data) ->
    @setState edit: false
    @props.onChange data

  _handleDrop: (groupId) ->
    Materialize.toast groupId, 3000, 'yellow'


  render: ->
    if @state.edit
      `<UserCharacterGroupForm group={ this.props.group }
                               onChange={ this._handleChange } />`

    else
      editable = @props.editable
      active = window.location.hash.substring(1) == @props.group.slug
      classNames = ['sortable-link']
      classNames.push 'active' if active

      `<li className={ classNames.join(' ') } ref='link' data-group-id={ this.props.group.slug }>
          <i className='material-icons left folder'>{ active ? 'folder_open' : 'folder' }</i>

          <Link to={ this.props.group.link } className='name'>
              { this.props.group.name }
          </Link>

          <span className='count'>
              { NumberUtils.format(this.props.group.characters_count) }
          </span>

          { editable &&
              <a href='#' onClick={ this._handleEdit } className='action'>
                  <i className='material-icons'>edit</i>
              </a> }
      </li>`
