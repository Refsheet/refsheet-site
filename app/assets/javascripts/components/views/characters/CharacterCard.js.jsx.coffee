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

  handleProfileImageEdit: ->
    $(document).trigger 'app:character:profileImage:edit'

  _handleFollow: (f) ->
    @setState HashUtils.set(@state, 'character.followed', f), ->
      Materialize.toast({ html: "Character #{if f then 'followed!' else 'unfollowed.'}", displayLength: 3000, classes: 'green' })
      
  _handleChange: (char) ->
    @props.onChange(char) if @props.onChange
    @setState character: char

  render: ->
    if @props.edit
      attributeUpdate = @handleAttributeChange
      notesUpdate = @handleSpecialNotesChange
      editable = true

    description =
      `<div className='description'>
          <AttributeTable onAttributeUpdate={ attributeUpdate }
                          defaultValue='Unspecified'
                          freezeName
                          hideEmpty={ !this.props.edit }
                          hideNotesForm>

              <Attribute id='species' name='Species' value={ this.state.character.species } />
          </AttributeTable>
          
          <Views.Character.Attributes characterPath={ this.state.character.path }
                                      attributes={ this.state.character.custom_attributes }
                                      onChange={ this._handleChange }
                                      editable={ editable }
          />

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

    gravity_crop = {
      center: { objectPosition: 'center' }
      north: { objectPosition: 'top' }
      south: { objectPosition: 'bottom' }
      east: { objectPosition: 'right' }
      west: { objectPosition: 'left' }
    }

    `<div className='character-card' style={{ minHeight: 400 }}>
        <div className='character-details'>
            <div className='heading'>
                <div className='right'>
                    <Views.User.Follow followed={ this.state.character.followed }
                                       username={ this.state.character.user_id }
                                       onFollow={ this._handleFollow }
                                       short />
                </div>

                <h1 className='name'>
                    <span className={ prefixClass }>{ this.props.titlePrefix } </span>
                    <span className='real-name'>{ this.state.character.name }</span>
                    { nickname }
                    <span className={ suffixClass }> { this.props.titleSuffix }</span>
                </h1>
            </div>

            { description }
        </div>

        {/*<div className='user-icon'>
            <Link to={ '/' + this.state.character.user_id } className='tooltipped' data-tooltip={ this.state.character.user_name } data-position='bottom'>
                <img className='circle' src={ this.state.character.user_avatar_url } />
            </Link>
        </div>*/}

        <div className='character-image' onClick={ this.handleImageClick }>
            <div className='slant' />
            <img src={ this.state.character.profile_image.medium }
                 data-image-id={ this.state.character.profile_image.id }
                 style={ gravity_crop[this.state.character.profile_image.gravity] } />

            { editable &&
                <a className='image-edit-overlay' onClick={ this.handleProfileImageEdit }>
                    <div className='content'>
                        <i className='material-icons'>photo_camera</i>
                        Change Image
                    </div>
                </a> }
        </div>
    </div>`