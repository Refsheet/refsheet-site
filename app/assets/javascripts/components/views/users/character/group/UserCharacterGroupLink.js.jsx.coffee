@UserCharacterGroupLink = React.createClass
  propTypes: ->
    group: React.PropTypes.object.isRequired
    editable: React.PropTypes.bool
    onChange: React.PropTypes.func

  getInitialState: ->
    edit: false
    dropOver: false

  componentDidMount: ->
    @_initialize()

  componentDidUpdate: ->
    @_initialize()


  _initialize: ->
    return unless @props.editable

    $link = $(@refs.link)

    $link.droppable
      tolerance: 'pointer'
      accept: '.character-drag'
      over: =>
        @setState dropOver: true

      out: =>
        @setState dropOver: false

      drop: (event, ui) =>
        $source = ui.draggable
        sourceId = $source.data 'character-id'
        @_handleDrop(sourceId)
        @setState dropOver: false


  _handleEdit: (e) ->
    @setState edit: true
    e.preventDefault()

  _handleChange: (data) ->
    @setState edit: false
    @props.onChange data

  _handleDrop: (characterId) ->
    Model.post @props.group.path + '/characters', id: characterId, (data) =>
      @props.onChange data


  render: ->
    if @state.edit
      `<UserCharacterGroupForm group={ this.props.group }
                               onChange={ this._handleChange } />`

    else
      editable = @props.editable
      active = window.location.hash.substring(1) == @props.group.slug
      classNames = ['sortable-link', 'character-group-drop']
      classNames.push 'active' if active

      if editable
        count = @props.group.characters_count
      else
        count = @props.group.visible_characters_count

      if @state.dropOver
        folder = 'add'
      else if active
        folder = 'folder_open'
      else
        folder = 'folder'

      `<li className={ classNames.join(' ') } ref='link' data-group-id={ this.props.group.slug }>
          <i className='material-icons left folder'>{ folder }</i>

          <Link to={ this.props.group.link } className='name'>
              { this.props.group.name }
          </Link>

          <span className='count'>
              { NumberUtils.format(count) }
          </span>

          { editable &&
              <a href='#' onClick={ this._handleEdit } className='action'>
                  <i className='material-icons'>edit</i>
              </a> }
      </li>`
