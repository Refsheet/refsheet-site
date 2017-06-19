@UserApp = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    currentUser: React.PropTypes.object
    eagerLoad: React.PropTypes.object

  dataPath: '/users/:userId'

  paramMap:
    userId: 'username'


  getInitialState: ->
    user: null
    error: null
    activeGroupId: null
    characterName: null


  componentDidMount: ->
    @setState activeGroupId: window.location.hash.substring(1), ->
      StateUtils.load @, 'user'

  componentWillReceiveProps: (newProps) ->
    @setState activeGroupId: window.location.hash.substring(1), ->
      StateUtils.reload @, 'user', newProps


  goToCharacter: (character) ->
    $('#character-form').modal('close')
    @context.router.push character.link

  handleUserChange: (user) ->
    @setState user: user

    if user.username == @context.currentUser.username
      @props.onLogin(user)


  #== Schnazzy Fancy Root-level permutation operations!

  _handleGroupChange: (group, character) ->
    StateUtils.updateItem @, 'user.character_groups', group, 'slug', ->
      if character
        HashUtils.findItem @state.user.characters, character, 'slug', (c) =>
          c.group_ids.push group.slug
          StateUtils.updateItem @, 'user.characters', c, 'slug'

  _handleGroupDelete: (groupId) ->
    @context.router.push @state.user.link if groupId is @state.activeGroupId
    StateUtils.removeItem @, 'user.character_groups', groupId, 'slug'

  _handleGroupSort: (group, position) ->
    StateUtils.sortItem @, 'user.character_groups', group, position, 'slug'

  _handleCharacterSort: (character, position) ->
    StateUtils.sortItem @, 'user.characters', character, position, 'slug'

  _handleGroupCharacterDelete: (group) ->
    @_handleGroupChange group


  #== Render

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
                <div className='sidebar-container'>
                    <div className='sidebar'>


                        { editable &&
                            <a href='#character-form' className='margin-bottom--large btn btn-block center waves-effect waves-light modal-trigger'>New Character</a>
                        }

                        <UserCharacterGroups groups={ this.state.user.character_groups }
                                             editable={ editable }
                                             totalCount={ this.state.user.characters_count }
                                             onChange={ this._handleGroupChange }
                                             onSort={ this._handleGroupSort }
                                             onGroupDelete={ this._handleGroupDelete }
                                             onCharacterDelete={ this._handleGroupCharacterDelete }
                                             activeGroupId={ this.state.activeGroupId }
                                             userLink={ this.state.user.link } />
                    </div>

                    <div className='main-content'>
                        <UserCharacters characters={ this.state.user.characters }
                                        activeGroupId={ this.state.activeGroupId }
                                        onSort={ this._handleCharacterSort }
                                        editable={ editable } />
                    </div>
                </div>
            </Section>
        </DropzoneContainer>
    </Main>`
