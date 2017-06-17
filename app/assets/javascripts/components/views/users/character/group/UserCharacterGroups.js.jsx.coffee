@UserCharacterGroups = React.createClass
  propTypes:
    userLink: React.PropTypes.string.isRequired
    groups: React.PropTypes.array.isRequired
    editable: React.PropTypes.bool
    totalCount: React.PropTypes.number
    onChange: React.PropTypes.func.isRequired
    onSort: React.PropTypes.func.isRequired


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
      update: (_, el) =>
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
      groups = @props.groups.map (group) ->
        `<UserCharacterGroupLink group={ group }
                                 editable={ editable }
                                 onChange={ onChange }
                                 key={ group.slug } />`

    `<div>
        <ul className='character-group-list' ref='list'>
            <li className={ 'all fixed' + (!window.location.hash ? ' active' : '') }>
                <i className='material-icons left folder'>person</i>
                <Link to={ this.props.userLink } className='name'>All Characters</Link>
                <span className='count'>{ NumberUtils.format(this.props.totalCount) }</span>
            </li>

            { groups }

            { editable &&
                <UserCharacterGroupForm onChange={ this.props.onChange } /> }

            { dragging &&
                <UserCharacterGroupTrash /> }
        </ul>

        { editable &&
            <div className='hint'>
                <div className='strong'>Hint:</div>
                <div className='text'>Drag groups and characters to rearrange. Drag characters to add them to groups.</div>
            </div> }
    </div>`
