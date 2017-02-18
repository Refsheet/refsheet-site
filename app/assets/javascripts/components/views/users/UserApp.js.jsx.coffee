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
        `<FixedActionButton clickToToggle={ true } className='teal lighten-1' tooltip='Menu' icon='menu'>
            <ActionButton className='green lighten-1 modal-trigger' tooltip='New Refsheet' href='#character-form' icon='note_add' />
            <ActionButton className='grey' tooltip='Sign Out' onClick={ this.handleSignOut } icon='exit_to_app' />
            <ActionButton className='blue darken-1 modal-trigger' tooltip='User Settings' href='#user-settings-modal' icon='settings' />
        </FixedActionButton>`

      userChangeCallback = @handleUserChange
      editable = true
      editPath = this.state.user.path

    characters = @state.user.characters.map (character) ->
      `<div className='col m3 s6' key={ character.slug }>
          <CharacterLinkCard path={ character.link }
                             name={ character.name }
                             profileImageUrl={ character.profile_image_url } />
      </div>`

    `<main>
        <DropzoneContainer url={ editPath }
                           method='PATCH'
                           clickable='.user-avatar'
                           paramName='user[avatar]'
                           onUpload={ this.handleUserChange }>

            <Modal id='character-form'>
                <h2>New Character</h2>
                <p>It all starts with the basics. Give us a name and a species, and we'll set up a profile.</p>
                <NewCharacterForm onCancel={ function(e) { $('#character-form').modal('close'); e.preventDefault() } }
                                  onCreate={ this.goToCharacter }
                                  newCharacterPath={ this.state.user.path + '/characters' }/>
            </Modal>

            { actionButtons }

            { editable &&
                <UserSettingsModal user={ this.state.user }
                                   onChange={ this.handleUserChange } />
            }

            <UserHeader { ...this.state.user } onUserChange={ userChangeCallback } />

            <div className='tab-row'>
                <div className='container'>
                    <Tabs>
                        <li className='tab'>
                            <Link to={ '/' + this.state.user.username } className='active'>Characters</Link>
                        </li>
                    </Tabs>
                </div>
            </div>

            <Section className='margin-top--large'>
                <div className='row'>
                    { characters }
                </div>

                { characters.length == 0 &&
                    <p className='caption center'>
                        { this.state.user.name } has no characters.
                    </p>
                }

                { editable &&
                    <div className='center margin-bottom--large'>
                        <a href='#character-form' className='margin-top--large btn center waves-effect waves-light modal-trigger'>New Character</a>
                    </div>
                }
            </Section>
        </DropzoneContainer>
    </main>`
