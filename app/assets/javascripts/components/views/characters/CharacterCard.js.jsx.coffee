@CharacterCard = React.createClass
  getInitialState: ->
    character: @props.character

  componentWillUpdate: (newProps) ->
    if newProps.character != @props.character
      @setState character: newProps.character

  handleAttributeChange: (data, onSuccess, onError) ->
    postData =
      character: {}
    postData.character[data.id] = data.value

    $.ajax
      url: @state.character.path
      type: 'PATCH'
      data: postData
      success: (data) =>
        @setState character: data
        onSuccess()
      error: (error) =>
        onError(value: error.JSONData?.errors[data.id])

  handleSpecialNotesChange: (markup, onSuccess, onError) ->
    $.ajax
      url: @state.character.path
      type: 'PATCH'
      data: character: special_notes: markup
      success: (data) =>
        @setState character: data
        onSuccess()
      error: (error) =>
        onError(error.JSONData?.errors['special_notes'])

  handleImageClick: (e) ->
    id = $(e.target).closest('[data-image-id]').data('image-id')
    @props.onLightbox(id) if @props.onLightbox?

  render: ->
    if @props.edit
      attributeUpdate = @handleAttributeChange
      notesUpdate = @handleSpecialNotesChange
      editable = true

    description =
      `<div className='description'>
          <AttributeTable onAttributeUpdate={ attributeUpdate }
                          defaultValue='Unspecified'
                          freezeName={ true }
                          hideNotesForm={ true }>

              <Attribute id='gender' name='Gender' value={ this.state.character.gender } />
              <Attribute id='species' name='Species' value={ this.state.character.species } />
              <Attribute id='height' name='Height / Weight' value={ this.state.character.height } />
              <Attribute id='body_type' name='Body Type' value={ this.state.character.body_type } />
          </AttributeTable>

          { (this.state.character.special_notes || editable) &&
              <div className='important-notes margin-top--large margin-bottom--medium'>
                  <h2>Important Notes</h2>
                  <RichText content={ this.state.character.special_notes_html }
                            markup={ this.state.character.special_notes }
                            onChange={ notesUpdate } />
              </div>
          }
      </div>`

    if @props.nickname
      nickname = `<span className='nickname'> ({ this.state.character.nickname })</span>`

    prefixClass = 'title-prefix'
    suffixClass = 'title-suffix'

    if @props.officialPrefix
      prefixClass += ' official'

    if @props.officialSuffix
      prefixClass += ' official'

    `<div className='character-card'>
        <div className='character-details'>
            <h1 className='name'>
                <span className={ prefixClass }>{ this.props.titlePrefix } </span>
                <span className='real-name'>{ this.state.character.name }</span>
                { nickname }
                <span className={ suffixClass }> { this.props.titleSuffix }</span>
            </h1>

            { description }
        </div>
        <div className='user-icon'>
            <Link to={ '/' + this.state.character.user_id } className='tooltipped' data-tooltip={ this.state.character.user_name } data-position='bottom'>
                <img className='circle' src={ this.state.character.user_avatar_url } />
            </Link>
        </div>
        <div className='character-image' onClick={ this.handleImageClick }>
            <div className='slant' />
            <img src={ this.state.character.profile_image.url } data-image-id={ this.state.character.profile_image.id } />
        </div>
    </div>`
