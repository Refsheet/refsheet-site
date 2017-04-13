@UserApp = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    currentUser: React.PropTypes.object


  getInitialState: ->
    user: null
    error: null
    characterName: null

  handleUserChange: (user) ->
    @setState user: user

    if user.username == @props.currentUser.username
      @props.onLogin(user)

  componentDidMount: ->
    $(document).trigger 'app:loading'
    console.debug "Loading User"

    $.ajax
      url: '/users/' + @props.params.userId + '.json'
      success: (data) =>
        @setState user: data

      error: (error) =>
          @setState error: error

      complete: ->
        $(document).trigger 'app:loading:done'

  goToCharacter: (character) ->
    $('#character-form').modal('close')
    @context.router.push character.link

  render: ->
    if @state.error?
      return `<NotFound />`

    unless @state.user?
      return `<main />`

    if @context.currentUser?.username == @state.user.username
      actionButtons =
        `<FixedActionButton clickToToggle={ true } className='teal lighten-1' tooltip='Menu' icon='menu' id='user-actions'>
            <ActionButton className='green lighten-1 modal-trigger' tooltip='New Refsheet' href='#character-form' icon='note_add' id='action-new-character' />
            <ActionButton className='blue darken-1 modal-trigger' tooltip='User Settings' href='#user-settings-modal' icon='settings' id='action-settings' />
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
                                  className='margin-top--large'
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
