@UserCharacterGroupTrash = React.createClass
  propTypes:
    onGroupDelete: React.PropTypes.func.isRequired
    onCharacterDelete: React.PropTypes.func.isRequired
    activeGroupId: React.PropTypes.string
    characterDragActive: React.PropTypes.bool

  getInitialState: ->
    dropOver: false

  componentDidMount: ->
    $trash = $(@refs.trash)

    $trash.droppable
      tolerance: 'pointer'
      accept: '.character-drag, .sortable-link'
      over: =>
        @setState dropOver: true

      out: =>
        @setState dropOver: false

      drop: (event, ui) =>
        console.log '===DROP'
        $source = ui.draggable
        $source.addClass 'dropped'

        if $source.data 'character-id'
          sourceId = $source.data 'character-id'
          @_handleCharacterDrop sourceId, ->
            $source.remove
        else
          sourceId = $source.data 'group-id'
          @_handleGroupDrop sourceId, ->
            $source.remove

        @setState dropOver: false

  _handleGroupDrop: (groupId, callback) ->
    Model.delete "/character_groups/#{groupId}", =>
      @props.onGroupDelete groupId
      callback()

  _handleCharacterDrop: (characterId, callback) ->
    Model.delete "/character_groups/#{@props.activeGroupId}/characters/#{characterId}", =>
      @props.onCharacterDelete characterId
      callback()

  render: ->
    if @state.dropOver
      icon = 'delete_forever'
    else
      icon = 'delete'

    if @props.characterDragActive
      message = 'Remove From Group'
    else
      message = 'Delete Group'

    `<li className='trash fixed' ref='trash'>
        <i className='material-icons left folder'>{ icon }</i>
        <span className='name'>{ message }</span>
    </li>`
