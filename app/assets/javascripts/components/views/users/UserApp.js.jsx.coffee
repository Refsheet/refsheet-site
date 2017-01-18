@UserApp = React.createClass
  getInitialState: ->
    user: null
    error: null
    characterName: null

  handleSignOut: (e) ->
    $.ajax
      url: '/session'
      type: 'DELETE'
      success: =>
        @props.onLogin null

    e.preventDefault()

  handleUserChange: (user) ->
    @setState user: user

    if user.username == @props.currentUser.username
      @props.onLogin(user)

  componentDidMount: ->
    $.ajax
      url: '/users/' + @props.params.userId + '.json'
      success: (data) =>
        @setState user: data

      error: (error) =>
          @setState error: error

  goToCharacter: (character) ->
    $('#character-form').modal('close')
    @props.history.push character.link

  render: ->
    if @state.error?
      return `<NotFound />`

    unless @state.user?
      return `<Loading />`

    if @props.currentUser?.username == @state.user.username
      actionButtons =
        `<FixedActionButton clickToToggle={ true } className='red darken-1' tooltip='Menu' icon='menu'>
            <ActionButton className='teal lighten-1 modal-trigger' tooltip='New Character' href='#character-form' icon='create' />
            <ActionButton className='grey' tooltip='Sign Out' onClick={ this.handleSignOut } icon='exit_to_app' />
        </FixedActionButton>`

      userChangeCallback = @handleUserChange

    characters = @state.user.characters.map (character) ->
      `<div className='col m3 s12' key={ character.slug }>
          <CharacterLinkCard path={ character.link }
                             name={ character.name }
                             profileImageUrl={ character.profile_image_url } />
      </div>`

    `<main>
        <Modal id='character-form'>
            <h2>New Character</h2>
            <p>It all starts with the basics. Give us a name and a species, and we'll set up a profile.</p>
            <NewCharacterForm onCancel={ function(e) { $('#character-form').modal('close'); e.preventDefault() } }
                              onCreate={ this.goToCharacter }
                              newCharacterPath={ this.state.user.path + '/characters' }/>
        </Modal>

        { actionButtons }

        <UserHeader { ...this.state.user } onUserChange={ userChangeCallback } />

        <Section className='pop-out'>
            <div className='row'>
                { characters }
            </div>

            { characters.length == 0 &&
                <p className='caption center'>{ this.state.user.name } has no characters.</p>
            }
        </Section>
    </main>`
