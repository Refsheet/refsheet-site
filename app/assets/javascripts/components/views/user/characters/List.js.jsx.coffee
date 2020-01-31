@User.Characters.List = v1 -> React.createClass
  propTypes:
    characters: React.PropTypes.array.isRequired
    onSort: React.PropTypes.func.isRequired
    editable: React.PropTypes.bool


  componentDidMount: ->
    @_initialize()

  componentDidUpdate: ->
    @_initialize()


  _initialize: ->
    return unless @props.editable
    $list = $(@refs.list)

    $list.sortable
      items: 'li'
      placeholder: 'drop-target col s6 m4 xl3'
      tolerance: 'pointer'
      cursorAt:
        top: 15
        left: 15
      update: (e, el) =>
        $item = $(el.item[0])

        if $item.hasClass 'dropped'
          $item.removeClass 'dropped'
          $list.sortable 'cancel'
        else
          position = $item.parent().children().index($item)
          @_handleSwap $item.data('character-id'), position

  _handleSwap: (characterId, position) ->
    character = (@props.characters.filter (c) -> c.slug == characterId)[0]

    Model.put character.path, character: row_order_position: position, (data) =>
      @props.onSort data, position


  render: ->
    if @props.characters.length
      if @props.activeGroupId
        characterScope = @props.characters.filter (c) =>
          c.group_ids.indexOf(@props.activeGroupId) isnt -1
      else
        characterScope = @props.characters

      characters = characterScope.map (character) ->
        `<li className='character-drag col s6 m4 xl3' key={ character.slug } data-character-id={ character.slug }>
            <CharacterLinkCard {...StringUtils.camelizeKeys(character)} />
        </li>`

      `<ul className='user-characters row' ref='list'>
          { characters }
      </ul>`

    else
      `<p className='caption center'>
          No characters to show here :(
      </p>`
