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

    `<DropzoneContainer url={ this.state.character.path + '/images' } onUpload={ dropzoneUpload }>
        <PageHeader backgroundImage={ this.state.character.featured_image.url }>
            <CharacterCard edit={ editable } detailView={ true } character={ this.state.character } onLightbox={ this.props.onLightbox } />
            <SwatchPanel edit={ editable } swatchesPath={ this.state.character.path + '/swatches/' } swatches={ this.state.character.swatches } />
        </PageHeader>

        <Section className='padded pop-out'>
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
