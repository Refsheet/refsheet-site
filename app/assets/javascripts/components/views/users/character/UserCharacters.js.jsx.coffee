@UserCharacters = React.createClass
  propTypes:
    characters: React.PropTypes.array.isRequired
    onSort: React.PropTypes.func.isRequired
    editable: React.PropTypes.bool


  componentDidMount: ->
    @_initialize()

  componentDidUpdate: ->
    @_initialize()


  _initialize: ->
    $list = $(@refs.list)

    $list.sortable
      items: 'li'
      placeholder: 'drop-target'
      stop: (_, el) =>
        $item = $(el.item[0])
        position = $item.parent().children().index($item)
        @_handleSwap $item.data('character-id'), position

  _handleSwap: (characterId, position) ->
    character = (@props.characters.filter (c) -> c.slug == id)[0]

    Model.put character.path, character: row_order_position: position, (data) =>
      @props.onSort data, position


  render: ->
    if @props.characters.length
      characters = @props.characters.map (character) ->
        `<li className='col s6 m4' key={ character.slug } data-character-id={ character.slug }>
            <CharacterLinkCard {...StringUtils.camelizeKeys(character)} />
        </li>`

      `<ul className='user-characters row' ref='list'>
          { characters }
      </ul>`

    else
      `<p className='caption center'>
          No characters to show here :(
      </p>`
