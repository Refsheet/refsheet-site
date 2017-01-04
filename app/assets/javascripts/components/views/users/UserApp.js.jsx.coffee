@UserApp = React.createClass
  getInitialState: ->
    characterName: null

  handleSignOut: (e) ->
    $.ajax
      url: '/session'
      type: 'DELETE'
      success: =>
        @props.onLogin null

    e.preventDefault()

  # TODO: This is going away.
  handleCreateCharacter: (e) ->
    $.ajax
      url: @state.user.path + 'characters'
      type: 'POST'
      data: { character: { name: @state.characterName } }
      success: (data) =>
        @props.history.push data.path
        
      error: ->
        Materialize.toast 'Unknown error!', 3000, 'red'
    
    e.preventDefault()

  setCharacterName: (k, v) ->
    @setState characterName: v

  componentDidMount: ->
    $.get '/users/' + @props.params.userId + '.json', (data) =>
      @setState user: data

  render: ->
    unless @state.user?
      return `<Loading />`

    if @props.currentUser.username == @state.user.username
      signOutButton =
        `<a className='btn' onClick={ this.handleSignOut }>Log Out</a>`

      characterForm =
        `<form onSubmit={ this.handleCreateCharacter }>
            <Input id='name' label='New Character Name' onChange={ this.setCharacterName } value={ this.state.characterName } />
            <button type='submit' className='btn'>Create Character</button>
        </form>`

    characters = @state.user.characters.map (character) =>
      _this = this
      `<div className='col m3 s12'>
          <CharacterLinkCard path={ character.path }
                             name={ character.name }
                             profileImageUrl={ character.profile_image_url } />
      </div>`

    `<main>
        <PageHeader backgroundImage='/assets/unsplash/sand.jpg'>
            <div className='character-card'>
                <div className='character-details'>
                    <h1 className='name'>
                        { this.state.user.name }
                    </h1>
                    <div className='descriptin'>
                        <p className='caption'>@{ this.state.user.username }</p>
                    </div>
                    <div className='actions'>
                        { signOutButton }
                    </div>
                </div>
            </div>
        </PageHeader>

        <div className='container'>
            <div className='row'>
                { characters }
            </div>

            <div className='card-panel'>
                { characterForm }
            </div>
        </div>

        { this.props.children }
    </main>`
