@CharacterApp = React.createClass
  getInitialState: ->
    character: null
    error: null
    
  componentDidMount: ->
    path = '/users/' + @props.params.userId + '/characters/' + @props.params.characterId
    
    $.ajax
      url: path,
      success: (data) =>
        @setState character: data
      error: (error) =>
        @setState error: error

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

  render: ->
    if @state.error?
      return `<NotFound />`

    unless @state.character?
      return `<Loading />`

    if @state.character.user_id == @props.currentUser?.username
      dropzoneUpload = @props.onLightbox
      editable = true
      profileChange = @handleProfileChange
      likesChange = @handleLikesChange
      dislikesChange = @handleDislikesChange
      colorSchemeFields = []

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

        colorSchemeFields.push `<Attribute key={ key } id={ key } name={ name } value={ value } iconColor={ value } icon='palette' placeholder='Not Set' />`

    `<DropzoneContainer url={ this.state.character.path + '/images' } onUpload={ dropzoneUpload }>
        { this.state.character.color_scheme && <PageStylesheet { ...this.state.character.color_scheme.color_data } /> }

        { editable &&
            <FixedActionButton clickToToggle className='red darken-1' tooltip='Menu' icon='menu'>
                <ActionButton className='teal lighten-1 modal-trigger' tooltip='Edit Page Colors' href='#color-scheme-form' icon='palette' />
            </FixedActionButton>
        }

        { editable &&
            <Modal id='color-scheme-form'>
                <h2>Page Color Scheme</h2>
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

        <PageHeader backgroundImage={ this.state.character.featured_image.url }>
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

        <ImageGallery edit={ editable } imagesPath={ this.state.character.path + '/images/' } onImageClick={ this.props.onLightbox } />
    </DropzoneContainer>`
