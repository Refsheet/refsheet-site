@CharacterApp = React.createClass
  getInitialState: ->
    character: null
    loaded: false
    
  componentDidMount: ->
    path = '/users/' + @props.params.userId + '/characters/' + @props.params.characterId
    
    $.get path, (data) =>
      @setState character: data, loaded: true

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
    if !@state.loaded
      loading = `<Loading />`

    else
      `<DropzoneContainer url={ this.state.character.path + '/images' } onUpload={ this.props.onLightbox }>
          <PageHeader backgroundImage={ this.state.character.featured_image.url }>
              <CharacterCard detailView={ true } character={ this.state.character } />
              <SwatchPanel edit={ true } swatchesPath={ this.state.character.path + '/swatches/' } swatches={ this.state.character.swatches } />
          </PageHeader>
          
          <Section className='padded pop-out'>
              <Row>
                  <Column m={12}>
                      <h1>About { this.state.character.name }</h1>
                      <RichText placeholder='No biography written.'
                                onChange={ this.handleProfileChange }
                                content={ this.state.character.profile_html }
                                markup={ this.state.character.profile } />
                  </Column>
              </Row>
              <Row className='margin-top--large'>
                  <Column m={6}>
                      <h2>Likes</h2>
                      <RichText placeholder='No likes specified.'
                                onChange={ this.handleLikesChange }
                                content={ this.state.character.likes_html }
                                markup={ this.state.character.likes } />
                  </Column>
                  <Column m={6}>
                      <h2>Dislikes</h2>
                      <RichText placeholder='No dislikes specified.'
                                onChange={ this.handleDislikesChange }
                                content={ this.state.character.dislikes_html }
                                markup={ this.state.character.dislikes } />
                  </Column>
              </Row>
          </Section>

          <ImageGallery edit={ true } imagesPath={ this.state.character.path + '/images/' } onImageClick={ this.props.onLightbox } />
      </DropzoneContainer>`
