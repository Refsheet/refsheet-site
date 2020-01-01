Component = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    eagerLoad: React.PropTypes.object
    currentUser: React.PropTypes.object


  getInitialState: ->
    character: null
    error: null
    galleryTitle: null
    onGallerySelect: null
    images: null
    editable: true

  dataPath: '/users/:userId/characters/:characterId'
  paramMap:
    characterId: 'id'
    userId: 'user_id'

  componentWillMount: ->
    StateUtils.load @, 'character'

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'character', newProps

  componentDidMount: ->
    @props.setUploadTarget(@state.character?.real_id)

    $(document)
      .on 'app:character:update', (e, character) =>
        if @state.character.real_id == character.real_id
          @setState character: character

      .on 'app:character:profileImage:edit', =>
        @setState
          galleryTitle: 'Select Profile Picture'
          onGallerySelect: (imageId) =>
            @setProfileImage(imageId)
            M.Modal.getInstance(document.getElementById('image-gallery-modal')).close()
        M.Modal.getInstance(document.getElementById('image-gallery-modal')).open()

      .on 'app:character:reload app:image:delete', (e, newPath = @state.character.path, callback = null) =>
        console.debug "[CharacterApp] Reloading character..."
        $.get "#{newPath}.json", (data) =>
          @setState character: data
          callback(data) if callback?

  componentWillUnmount: ->
    $(document).off 'app:character:update'
    $(document).off 'app:character:profileImage:edit'
    $(document).off 'app:character:reload'
    $(document).off 'app:image:delete'


  componentWillUpdate: (newProps, newState) ->
    if newState.character && @state.character && newState.character.link != @state.character.link
      window.history.replaceState {}, '', newState.character.link
      @props.setUploadTarget(@state.character?.real_id)


  setFeaturedImage: (imageId) ->
    $.ajax
      url: @state.character.path
      type: 'PATCH'
      data: { character: { featured_image_guid: imageId } }
      success: (data) =>
        Materialize.toast 'Cover image changed!', 3000, 'green'
        @setState character: data
      error: (error) =>
        errors = error.responseJSON.errors
        Materialize.toast errors.featured_image, 3000, 'red'

  setProfileImage: (imageId) ->
    $.ajax
      url: @state.character.path
      type: 'PATCH'
      data: { character: { profile_image_guid: imageId } }
      success: (data) =>
        Materialize.toast 'Profile image changed!', 3000, 'green'
        @setState character: data
      error: (error) =>
        errors = error.responseJSON.errors
        Materialize.toast errors.profile_image, 3000, 'red'

  handleProfileChange: (data, onSuccess, onError) ->
    $.ajax
      url: @state.character.path
      data: character: profile: data
      type: 'PATCH'
      success: (data) =>
        @setState character: data
        onSuccess()
      error: (error) =>
        onError(error)

  handleLikesChange: (data, onSuccess, onError) ->
    $.ajax
      url: @state.character.path
      data: character: likes: data
      type: 'PATCH'
      success: (data) =>
        @setState character: data
        onSuccess()
      error: (error) =>
        onError(error)

  handleDislikesChange: (data, onSuccess, onError) ->
    $.ajax
      url: @state.character.path
      data: character: dislikes: data
      type: 'PATCH'
      success: (data) =>
        @setState character: data
        onSuccess()
      error: (error) =>
        onError(error)

  handleHeaderImageEdit: ->
    @setState
      galleryTitle: 'Select Header Image'
      onGallerySelect: (imageId) =>
        @setFeaturedImage(imageId)
        M.Modal.getInstance(document.getElementById('image-gallery-modal')).close()
    M.Modal.getInstance(document.getElementById('image-gallery-modal')).open()

  handleDropzoneUpload: (data) ->
    i = @state.images
    i.push data
    @setState images: i


  _handleGalleryLoad: (data) ->
    @setState images: data

  _toggleEditable: ->
    @setState editable: !@state.editable

  _openUploads: ->
    @props.openUploadModal()

  render: ->
    if @state.error?
      return `<NotFound />`

    unless @state.character?
      return `<CharacterViewSilhouette />`

    if @state.character.version == 2
      return `<Packs.application.CharacterController />`

    if @state.character.user_id == @context.currentUser?.username
      showMenu = true

      if @state.editable
        editable = true
        dropzoneUpload = @handleDropzoneUpload
        profileChange = @handleProfileChange
        likesChange = @handleLikesChange
        dislikesChange = @handleDislikesChange
        headerImageEditCallback = @handleHeaderImageEdit
        dropzoneTriggerId = [ '#image-upload' ]


    `<Main title={[ this.state.character.name, 'Characters' ]}>
        { this.state.character.color_scheme &&
            <PageStylesheet colorData={ this.state.character.color_scheme.color_data } /> }

        {/*<CharacterEditMenu onEditClick={ this._toggleEditable }
                              images={ this.state.images }
                              galleryTitle={ this.state.galleryTitle } <-- THIS SHOULD NOT HAPPEN
                              onGallerySelect={ this.onGallerySelect }
                              character={ this.state.character } */}

        { showMenu &&
            <div className='edit-container'>
                <FixedActionButton clickToToggle className='red' tooltip='Menu' icon='menu'>
                    <ActionButton className='indigo lighten-1' tooltip='Upload Images' id='image-upload' onClick={ this._openUploads } icon='file_upload' />
                    <ActionButton className='green lighten-1 modal-trigger' tooltip='Edit Page Colors' href='#color-scheme-form' icon='palette' />
                    <ActionButton className='blue darken-1 modal-trigger' tooltip='Character Settings' href='#character-settings-form' icon='settings' />

                    { editable
                        ? <ActionButton className='red lighten-1' tooltip='Lock Page' icon='lock' onClick={ this._toggleEditable } />
                        : <ActionButton className='red lighten-1' tooltip='Edit Page' icon='edit' onClick={ this._toggleEditable } /> }
                </FixedActionButton>

                <ImageGalleryModal images={ this.state.images }
                                   title={ this.state.galleryTitle }
                                   onClick={ this.state.onGallerySelect }
                                   onUploadClick={ this._openUploads }
                />

                <CharacterColorSchemeModal colorScheme={ this.state.character.color_scheme } characterPath={ this.state.character.path } />
                <CharacterDeleteModal character={ this.state.character } />
                <CharacterTransferModal character={ this.state.character } />
                <CharacterSettingsModal character={ this.state.character } />
            </div>
        }

        <PageHeader backgroundImage={ (this.state.character.featured_image || {}).url }
                    onHeaderImageEdit={ headerImageEditCallback }>

            <CharacterNotice transfer={ this.state.character.pending_transfer } />

            { showMenu &&
                <div className='button-group'>
                    { editable
                        ? <ActionButton className='red lighten-1' tooltip='Lock Page' icon='lock' onClick={ this._toggleEditable } />
                        : <ActionButton className='red lighten-1' tooltip='Edit Page' icon='edit' onClick={ this._toggleEditable } /> }
                </div> }

            <CharacterCard edit={ editable } detailView={ true } character={ this.state.character } onLightbox={ this.props.onLightbox } />
            <SwatchPanel edit={ editable } swatchesPath={ this.state.character.path + '/swatches/' } swatches={ this.state.character.swatches } />

        </PageHeader>

        <Section>
            <Row className='rowfix'>
                <Column m={12}>
                    <div className='card-panel margin--none'>
                        <h1>About { this.state.character.name }</h1>
                        <RichText placeholder='No biography written.'
                                  onChange={ profileChange }
                                  content={ this.state.character.profile_html }
                                  markup={ this.state.character.profile } />
                    </div>
                </Column>
            </Row>
            <Row className='rowfix'>
                <Column m={6}>
                    <div className='card-panel margin--none'>
                        <h2>Likes</h2>
                        <RichText placeholder='No likes specified.'
                                  onChange={ likesChange }
                                  content={ this.state.character.likes_html }
                                  markup={ this.state.character.likes } />
                    </div>
                </Column>
                <Column m={6}>
                    <div className='card-panel margin--none'>
                        <h2>Dislikes</h2>
                        <RichText placeholder='No dislikes specified.'
                                  onChange={ dislikesChange }
                                  content={ this.state.character.dislikes_html }
                                  markup={ this.state.character.dislikes } />
                    </div>
                </Column>
            </Row>
        </Section>

        <Section className='margin-bottom--large'>
            <ImageGallery editable={ editable }
                          imagesPath={ this.state.character.path + '/images/' }
                          images={ this.state.images }
                          onImagesLoad={ this._handleGalleryLoad } />
        </Section>
    </Main>`

mapDispatchToProps = {
  setUploadTarget: setUploadTarget,
  openUploadModal: Actions.openUploadModal
}

mapStateToProps = (state) ->
  state

@CharacterApp = connect(mapStateToProps, mapDispatchToProps)(Component)