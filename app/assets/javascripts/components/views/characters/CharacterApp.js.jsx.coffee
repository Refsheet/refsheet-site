@CharacterApp = React.createClass
  getInitialState: ->
    character: null
    error: null
    galleryTitle: null
    onGallerySelect: null

  componentDidMount: ->
    $.ajax
      url: "/users/#{@props.params.userId}/characters/#{@props.params.characterId}.json",
      success: (data) =>
        @setState character: data
        @componentDidLoad(data)
      error: (error) =>
        @setState error: error
        
    $(document)
      .on 'app:character:update', (e, character) =>
        if @state.character.id == character.id
          @setState character: character

      .on 'app:character:profileImage:edit', =>
        @setState
          galleryTitle: 'Select Profile Picture'
          onGallerySelect: (imageId) =>
            @setProfileImage(imageId)
            $('#image-gallery-modal').modal 'close'
        $('#image-gallery-modal').modal 'open'

  componentWillUpdate: (newProps, newState) ->
    if newState.character && @state.character && newState.character.link != @state.character.link
      window.history.replaceState {}, '', newState.character.link

  componentDidLoad: (character) ->
    $(document).on 'app:image:delete', (imageId) =>
      @setState character: null
      $.get "/users/#{@props.params.userId}/characters/#{@props.params.characterId}.json", (data) =>
        @setState character: data

  setFeaturedImage: (imageId) ->
    $.ajax
      url: @state.character.path
      type: 'PATCH'
      data: { character: { featured_image_guid: imageId } }
      success: (data) =>
        Materialize.toast 'Cover image changed!', 3000, 'green'
        @setState character: data
      error: (error) =>
        console.log error
        Materialize.toast 'Error?', 3000, 'red'

  setProfileImage: (imageId) ->
    $.ajax
      url: @state.character.path
      type: 'PATCH'
      data: { character: { profile_image_guid: imageId } }
      success: (data) =>
        Materialize.toast 'Profile image changed!', 3000, 'green'
        @setState character: data
      error: (error) =>
        console.log error
        Materialize.toast 'Error?', 3000, 'red'

  handleCharacterDelete: (e) ->
    $.ajax
      url: @state.character.path
      type: 'DELETE'
      success: (data) =>
        console.log data
        $('#delete-form').modal('close')
        Materialize.toast "#{data.name} deleted. :(", 3000
        @props.history.push '/' + data.user_id

      error: (error) =>
        Materialize.toast "I'm afraid I couldn't do that, Jim.", 3000, 'red'
    e.preventDefault()

  handleDeleteClose: (e) ->
    $('#delete-form').modal('close')
    e.preventDefault()

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

  handleColorSchemeChange: (data, onSuccess, onError) ->
    c = @state.character.color_scheme
    c = { color_data: {} } unless c && c.color_data
    c.color_data[data.id] = data.value

    $.ajax
      url: @state.character.path
      data: character: color_scheme_attributes: c
      type: 'PATCH'
      success: (data) =>
        @setState character: data
        onSuccess() if onSuccess
      error: (error) =>
        onError(error) if onError

  handleColorSchemeClear: (key, onSuccess, onError) ->
    data = { id: key, value: null }
    @handleColorSchemeChange(data)

  handleColorSchemeClose: (e) ->
    $('#color-scheme-form').modal('close')

  handleSettingsChange: (data, onSuccess, onError) ->
    o = {}
    o[data.id] = data.value

    console.log data

    $.ajax
      url: @state.character.path
      data: character: o
      type: 'PATCH'
      success: (data) =>
        @setState character: data
        onSuccess() if onSuccess
      error: (error) =>
        e = error.responseJSON.errors[data.id]
        onError(value: e) if onError

  handleSettingsClose: (e) ->
    $('#character-settings-form').modal('close')

  handleHeaderImageEdit: ->
    @setState
      galleryTitle: 'Select Header Image'
      onGallerySelect: (imageId) =>
        @setFeaturedImage(imageId)
        $('#image-gallery-modal').modal 'close'
    $('#image-gallery-modal').modal 'open'

  handleDropzoneUpload: (data) ->
    c = @state.character
    c.images.push data
    console.log c.images
    @setState character: c

  render: ->
    if @state.error?
      return `<NotFound />`

    unless @state.character?
      return `<Loading />`

    if @state.character.user_id == @props.currentUser?.username
      dropzoneUpload = @handleDropzoneUpload
      editable = true
      profileChange = @handleProfileChange
      likesChange = @handleLikesChange
      dislikesChange = @handleDislikesChange
      colorSchemeFields = []
      headerImageEditCallback = @handleHeaderImageEdit

      for key, name of {
        primary: 'Primary Accent'
        accent1: 'Secondary Accent'
        accent2: 'Third Accent'
        text: 'Main Text'
        'text-medium': 'Medium Text'
        'text-light': 'Light Text'
        background: 'Page Background'
        'card-background': 'Card Background'
      }
        if @state.character.color_scheme && @state.character.color_scheme.color_data
          value = @state.character.color_scheme.color_data[key]

        colorSchemeFields.push `<Attribute key={ key }
                                           id={ key }
                                           name={ name }
                                           value={ value }
                                           iconColor={ value || '#000000' }
                                           icon='palette'
                                           placeholder='Not Set' />`

    `<DropzoneContainer url={ this.state.character.path + '/images' }
                        onUpload={ dropzoneUpload }
                        clickable={[ '#image-upload' ]}>
        { this.state.character.color_scheme && <PageStylesheet { ...this.state.character.color_scheme.color_data } /> }

        { editable &&
            <FixedActionButton clickToToggle className='teal lighten-1' tooltip='Menu' icon='menu'>
                <ActionButton className='indigo lighten-1' tooltip='Upload Images' id='image-upload' icon='file_upload' />
                <ActionButton className='green lighten-1 modal-trigger' tooltip='Edit Page Colors' href='#color-scheme-form' icon='palette' />
                <ActionButton className='blue darken-1 modal-trigger' tooltip='Character Settings' href='#character-settings-form' icon='settings' />
            </FixedActionButton>
        }

        { editable &&
            <Modal id='color-scheme-form'>
                <h2>Page Color Scheme</h2>
                <p>Be sure to save each row individually. Click the trash bin to revert the color to Refsheet's default.</p>

                <AttributeTable valueType='color'
                                onAttributeUpdate={ this.handleColorSchemeChange }
                                onAttributeDelete={ this.handleColorSchemeClear }
                                freezeName hideNotesForm>
                    { colorSchemeFields }
                </AttributeTable>

                <div className='actions margin-top--large'>
                  <a className='btn' onClick={ this.handleColorSchemeClose }>Done</a>
                </div>
            </Modal>
        }

        { editable &&
            <Modal id='delete-form'>
                <h2>Delete Character</h2>
                <p>This action can not be undone! Are you sure?</p>

                <div className='actions margin-top--large'>
                    <a className='btn red right' onClick={ this.handleCharacterDelete }>DELETE CHARACTER</a>
                    <a className='btn' onClick={ this.handleDeleteClose }>Cancel</a>
                </div>
            </Modal>
        }

        { editable &&
            <Modal id='character-settings-form'>
                <h2>Character Settings</h2>
                <p>Be sure to save each row individually. Do note that your URL slug is not case-sensitive, but changing it
                might break existing links to your character.</p>

                <AttributeTable onAttributeUpdate={ this.handleSettingsChange }
                                freezeName hideNotesForm>
                    <Attribute id='name' name='Character Name' value={ this.state.character.name } />
                    <Attribute id='slug' name='URL Slug' value={ this.state.character.slug } />
                    <li>
                        <div className='attribute-data'>
                            <div className='key'>Delete</div>
                            <div className='value'>
                                <a className='red-text btn-small modal-trigger' href='#delete-form'>Delete Character</a>
                            </div>
                        </div>
                        <div className='actions' />
                    </li>
                </AttributeTable>

                <div className='actions margin-top--large'>
                    <a className='btn' onClick={ this.handleSettingsClose }>Done</a>
                </div>
            </Modal>
        }

        { editable &&
            <ImageGalleryModal images={ this.state.character.images }
                               title={ this.state.galleryTitle }
                               onClick={ this.state.onGallerySelect } />
        }

        <PageHeader backgroundImage={ (this.state.character.featured_image || {}).url }
                    onHeaderImageEdit={ headerImageEditCallback }>
            <CharacterCard edit={ editable } detailView={ true } character={ this.state.character } onLightbox={ this.props.onLightbox } />
            <SwatchPanel edit={ editable } swatchesPath={ this.state.character.path + '/swatches/' } swatches={ this.state.character.swatches } />
        </PageHeader>

        <Section className='padded pop-out margin-top--xlarge margin-bottom--xlarge'>
            <Row>
                <Column m={12}>
                    <h1>About { this.state.character.name }</h1>
                    <RichText placeholder='No biography written.'
                              onChange={ profileChange }
                              content={ this.state.character.profile_html }
                              markup={ this.state.character.profile } />
                </Column>
            </Row>
            <Row className='margin-top--large'>
                <Column m={6}>
                    <h2>Likes</h2>
                    <RichText placeholder='No likes specified.'
                              onChange={ likesChange }
                              content={ this.state.character.likes_html }
                              markup={ this.state.character.likes } />
                </Column>
                <Column m={6}>
                    <h2>Dislikes</h2>
                    <RichText placeholder='No dislikes specified.'
                              onChange={ dislikesChange }
                              content={ this.state.character.dislikes_html }
                              markup={ this.state.character.dislikes } />
                </Column>
            </Row>
        </Section>

        <Section>
            <ImageGallery edit={ editable }
                          imagesPath={ this.state.character.path + '/images/' }
                          onImageClick={ this.props.onLightbox }
                          images={ this.state.character.images } />
        </Section>

    </DropzoneContainer>`
