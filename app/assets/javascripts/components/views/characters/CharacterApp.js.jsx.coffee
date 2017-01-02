@CharacterApp = React.createClass
  getInitialState: ->
    character: null
    loaded: false
    
  componentDidMount: ->
    path = '/users/' + @props.params.userId + '/characters/' + @props.params.characterId
    
    $.get path, (data) =>
      @setState character: data, loaded: true

  render: ->
    if !@state.loaded
      loading = `<Loading />`

    else
      `<main>
          <DropzoneContainer url={ this.state.character.path + '/images' }>
              { React.cloneElement(this.props.children, { character: this.state.character }) }
          </DropzoneContainer>
      </main>`
