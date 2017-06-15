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

    if user.username == @context.currentUser.username
      @props.onLogin(user)

  load: (userId) ->
    @setState user: null
    $(document).trigger 'app:loading'

    if window.location.hash
      data = character_group_id: window.location.hash.substring 1

    $.ajax
      url: '/users/' + userId + '.json'
      type: 'GET'
      data: data
      success: (data) =>
        @setState user: data
      error: (error) =>
          @setState error: error
      complete: ->
        $(document).trigger 'app:loading:done'

  componentDidMount: ->
    @load @props.params.userId

  componentWillReceiveProps: (newProps) ->
    if newProps.params.userId isnt @props.params.userId
      @load newProps.params.userId

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
      `<Column s={6} m={4} key={ character.slug }>
          <CharacterLinkCard {...StringUtils.camelizeKeys(character)} />
      </Column>`

    `<Main title={[ this.state.user.name, 'Users' ]}>
        <DropzoneContainer url={ editPath }
                           method='PATCH'
                           clickable='.user-avatar'
                           paramName='user[avatar]'
                           onUpload={ this.handleUserChange }>

            { editable &&
                <Modal id='character-form' title='New Character'>
                    <p>It all starts with the basics. Give us a name and a species, and we'll set up a profile.</p>
                    <NewCharacterForm onCancel={ function(e) { $('#character-form').modal('close'); e.preventDefault() } }
                                      onCreate={ this.goToCharacter }
                                      className='margin-top--large'
                                      newCharacterPath={ this.state.user.path + '/characters' }/>
                </Modal>
            }

            { actionButtons }

            { editable &&
                <UserSettingsModal user={ this.state.user }
                                   onChange={ this.handleUserChange } />
            }

            <UserHeader { ...this.state.user } onUserChange={ userChangeCallback } />

            <Section className='margin-top--large padding-bottom--none'>
                <Row noPad>
                    <Column m={3}>
                        { editable &&
                            <a href='#character-form' className='margin-bottom--large btn btn-block center waves-effect waves-light modal-trigger'>New Char</a>
                        }

                        <div className='caption center'>Character groups coming soon!</div>
                    </Column>

                    <Column m={9}>
                        <Row>{ characters }</Row>

                        { characters.length == 0 &&
                            <p className='caption center'>
                                { this.state.user.name } has no characters.
                            </p>
                        }
                    </Column>
                </Row>
            </Section>
        </DropzoneContainer>
    </Main>`
