@User.Characters.Groups = v1 -> React.createClass
  propTypes:
    userLink: React.PropTypes.string.isRequired
    groups: React.PropTypes.array.isRequired
    editable: React.PropTypes.bool
    totalCount: React.PropTypes.number
    onChange: React.PropTypes.func.isRequired
    onSort: React.PropTypes.func.isRequired
    onGroupDelete: React.PropTypes.func.isRequired
    onCharacterDelete: React.PropTypes.func.isRequired
    activeGroupId: React.PropTypes.string

  getInitialState: ->
    dragging: false

  componentDidMount: ->
    @_initialize()

  componentDidUpdate: ->
    @_initialize()


  _initialize: ->
    $list = $(@refs.list)

    $list.sortable
      items: 'li.sortable-link'
      placeholder: 'drop-target'
      forcePlaceholderSize: true
      start: =>
        @setState dragging: true

      stop: (_, el) =>
        @setState dragging: false

      update: (_, el) =>
        @setState dragging: false
        if $(el.item[0]).hasClass 'dropped'
          $(el.item[0]).removeClass 'dropped'
          $list.sortable('cancel')

        else
          $item = $(el.item[0])
          position = $item.parent().children('.sortable-link').index($item)
          @_handleSwap $item.data('group-id'), position

  _handleSwap: (id, position) ->
    group = (@props.groups.filter (g) -> g.slug == id)[0]

    Model.put group.path, character_group: row_order_position: position, (data) =>
      @props.onSort data, position


  render: ->
    { onChange, editable } = @props
    dragging = false

    if @props.groups.length
      _this = this

      groups = @props.groups.map (group) ->
        `<UserCharacterGroupLink group={ group }
                                 editable={ editable }
                                 onChange={ onChange }
                                 active={ _this.props.activeGroupId == group.slug }
                                 key={ group.slug } />`

    `<div>
        <ul className='character-group-list margin-bottom--none' ref='list'>
            <li className={ 'all fixed' + (!window.location.hash ? ' active' : '') }>
                <i className='material-icons left folder'>person</i>
                <Link to={ this.props.userLink } className='name'>All Characters</Link>
                <span className='count'>{ NumberUtils.format(this.props.totalCount) }</span>
            </li>

            { groups }

        </ul>

        { editable &&
            <ul className='character-group-list'>
                { this.state.dragging
                    ? <UserCharacterGroupTrash onChange={ this.props.onChange }
                                               onCharacterDelete={ this.props.onCharacterDelete }
                                               onGroupDelete={ this.props.onGroupDelete }
                                               activeGroupId={ this.props.activeGroupId } />
                    : <UserCharacterGroupForm onChange={ this.props.onChange } />
                }

                { dragging &&
                    <UserCharacterGroupTrash /> }
            </ul>
        }

        { editable &&
            <div className='hint'>
                <div className='strong'>Hint:</div>
                <div className='text'>Drag groups and characters (on All Characters page) to rearrange. Drag characters to a group to add/remove.</div>
            </div> }
    </div>`
