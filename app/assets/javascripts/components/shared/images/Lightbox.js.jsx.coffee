@Lightbox = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired
    currentUser: React.PropTypes.object


  getInitialState: ->
    image: null
    error: null
    directLoad: false

  handleCaptionChange: (data, onSuccess, onError) ->
    $.ajax
      url: @state.image.path
      type: 'PATCH'
      data: image: caption: data
      success: (data) =>
        @setState image: data
        onSuccess()
      error: (error) =>
        onError(error)

  setFeaturedImage: (e) ->
    $.ajax
      url: @state.image.character.path
      type: 'PATCH'
      data: { character: { featured_image_guid: @state.image.id } }
      success: (data) =>
        Materialize.toast 'Cover image changed!', 3000, 'green'
        $(document).trigger 'app:character:update', data

      error: (error) =>
        console.log error
        Materialize.toast 'Error?', 3000, 'red'

    e.preventDefault()

  setProfileImage: (e) ->
    $.ajax
      url: @state.image.character.path
      type: 'PATCH'
      data: { character: { profile_image_guid: @state.image.id } }
      success: (data) =>
        Materialize.toast 'Profile image changed!', 3000, 'green'
        $(document).trigger 'app:character:update', data

      error: (error) =>
        console.error error
        Materialize.toast 'Error?', 3000, 'red'

    e.preventDefault()

  handleDelete: (e) ->
    $.ajax
      url: @state.image.path
      type: 'DELETE'
      success: =>
        id = @state.image.id

        Materialize.toast('Image deleted.', 3000, 'green')
        $(document).trigger 'app:image:delete', id
        @state.onDelete(id) if @props.onDelete
        $('#lightbox-delete-form').modal('close')
        $('#lightbox').modal('close')
      error: =>
        Materialize.toast('Could not delete that for some reason.', 3000, 'red')
    e.preventDefault()

  handleClose: (e) ->
    return unless @state.image

    if @state.directLoad
      @context.router.push @state.image.character.link
    else
      window.history.back()

    @setState image: null, onChange: null

  componentDidMount: ->
    $('#lightbox').modal
      starting_top: '4%'
      ending_top: '10%'
      ready: ->
        $(this).find('.autofocus').focus()
        $(document).trigger 'materialize:modal:ready'
      complete: (e) =>
        @handleClose(e)

    $(document)
      .on 'app:lightbox', (e, imageId, onChange) =>
        console.debug '[Lightbox] Launching from event with:', imageId, onChange

        if typeof imageId == 'object' and not imageId.comments
          imageId = imageId.id

        if typeof imageId != 'object'
          $.ajax
            url: "/images/#{imageId}.json"
            success: (data) =>
              @setState image: data, onChange: onChange
              window.history.pushState {}, "", data.path

            error: (error) =>
              @setState error: "Image #{error.statusText}"
        else
          @setState image: imageId, directLoad: imageId.directLoad, onChange: onChange
          window.history.pushState {}, "", imageId.path

        $('#lightbox').modal('open')

  _handleChange: (image) ->
    Materialize.toast "Image saved!", 3000, 'green'
    @setState image: image, @_callback

  _handleUpdate: (image) ->
    @setState image: image if image.background_color

  _handleComment: (comment) ->
    if typeof comment.map != 'undefined'
      StateUtils.updateItems @, 'image.comments', comment, 'id', @_callback
    else
      StateUtils.updateItem @, 'image.comments', comment, 'id', @_callback

  _handleFavorite: (favorite, set=true) ->
    if set
      StateUtils.updateItem @, 'image.favorites', favorite, 'id', @_callback
    else
      StateUtils.removeItem @, 'image.favorites', favorite, 'id', @_callback

  _callback: ->
    return unless @state.image
    image = HashUtils.set @state.image, 'comments_count', @state.image.comments.length
    ObjectPath.set image, 'favorites_count', @state.image.favorites.length
    console.debug '[Lightbox] Callback with', image
    @state.onChange image if @state.onChange

  componentDidUpdate: ->
    $('.dropdown-button').dropdown
      constrain_width: false

  render: ->
    poll = true

    if @state.image?
      if @state.image.user_id == @context.currentUser?.username
        imgActionMenu =
          `<div className='image-action-menu'>
              <ul id='lightbox-image-actions' className='dropdown-content cs-card-background--background-color'>
                  <li><a href='#' onClick={ this.setFeaturedImage }>Set as Cover Image</a></li>
                  <li><a href='#' onClick={ this.setProfileImage }>Set as Profile Image</a></li>

                  <li className='divider' />

                  <li><a href='#image-gravity-modal' className='modal-trigger'>
                      <i className='material-icons left'>crop</i>
                      <span>Cropping...</span>
                  </a></li>

                  <li className='divider' />

                  <li><a href={ this.state.image.path + '/full' } target='_blank'>
                      <i className='material-icons left'>file_download</i>
                      <span>Download</span>
                  </a></li>

                  <li><a href='#lightbox-delete-form' className='modal-trigger' id='image-delete-link'>
                      <i className='material-icons left'>delete</i>
                      <span>Delete...</span>
                  </a></li>
              </ul>

              <a className='dropdown-button' id='image-actions-menu' href='#image-options' data-activates='lightbox-image-actions'>
                  <i className='material-icons'>more_vert</i>
              </a>
          </div>`

        captionCallback = @handleCaptionChange
        editable = true

      lightbox =
        `<div className='lightbox'>
            <div className='image-content' style={{backgroundColor: this.state.image.background_color}}>
                <img src={ this.state.image.url } />
            </div>

            <div className='image-details-container'>
                <div className='image-details'>
                    <div className='image-actions'>
                        { this.context.currentUser &&
                            <FavoriteButton mediaId={ this.state.image.id }
                                            favorites={ this.state.image.favorites }
                                            onFavorite={ this._handleFavorite } />
                        }

                        { imgActionMenu }
                    </div>
                    
                    <LightboxCharacterBox character={ this.state.image.character }
                                          postDate={ this.state.image.post_date }
                                          nsfw={ this.state.image.nsfw }
                                          hidden={ this.state.image.hidden } />

                    <RichText className='image-caption'
                              onChange={ captionCallback }
                              content={ this.state.image.caption_html }
                              markup={ this.state.image.caption }
                              placeholder='No caption.' />

                    { this.state.image.source_url &&
                        <div className='source-url'>
                            <i className='material-icons left'>link</i>
                            <a href={ this.state.image.source_url } target='_blank'>
                                { this.state.image.source_url_display }
                            </a>
                        </div> }
                </div>
                
                <Tabs className='comments'>
                    <Tab id='image-comments' name='Comments' className='padding--none flex-vertical' count={ this.state.image.comments.length }>
                        <Comments.Index comments={ this.state.image.comments }
                                        mediaId={ this.state.image.id }
                                        onCommentChange={ this._handleComment }
                                        onCommentsChange={ this._handleComment }
                                        poll={ poll } />
                    </Tab>

                    <Tab id='image-favorites' name='Favorites' count={ this.state.image.favorites.length }>
                        <Favorites.Index favorites={ this.state.image.favorites }
                                         mediaId={ this.state.image.id }
                                         onFavoriteChange={ this._handleFavorite }
                                         poll={ poll } />
                    </Tab>

                    { editable &&
                        <Tab id='image-settings' icon='settings'>
                            <Form model={ this.state.image }
                                  modelName='image'
                                  action={ this.state.image.path }
                                  onChange={ this._handleChange }
                                  onUpdate={ this._handleUpdate }
                                  changeEvent='app:image:update'
                                  method='PATCH'
                            >
                                <Input name='title' label='Title' />
                                <Input name='source_url' label='Source URL' hint='This should credit the artist or creator.' />
                                <Input name='background_color' type='color' icon='' label='Background Color' hint='Especially useful for transparent images!' />

                                <Row noMargin>
                                    <Column s={6}>
                                        <Input name='nsfw' type='checkbox' label='NSFW' />
                                    </Column>
                                    <Column s={6}>
                                        <Input name='hidden' type='checkbox' label='Hidden' />
                                    </Column>
                                </Row>

                                <div className='right margin-top--large'>
                                    <Submit>Save Image</Submit>
                                </div>
                            </Form>
                        </Tab>
                    }
                </Tabs>
            </div>
        </div>`
    else
      lightbox =
        `<div className='loader center padding--large'>
            {( this.state.error ? <h1>{ this.state.error }</h1> : <Spinner /> )}
        </div>`

    `<div>
        { editable &&
            <Modal id='lightbox-delete-form' title='Delete Image'>
                <p>Are you sure? This can't be undone.</p>
                <Row className='actions margin-top--large'>
                    <Column>
                        <div className='right'>
                            <a href='#' className='btn red right' onClick={ this.handleDelete } id='image-delete-confirm'>DELETE IMAGE</a>
                        </div>

                        <a href='#' className='btn' onClick={ function(e) { $('#lightbox-delete-form').modal('close'); e.preventDefault() } }>Cancel</a>
                    </Column>
                </Row>
            </Modal>
        }

        { editable && <ImageGravityModal image={ this.state.image } /> }


        <Modal className='lightbox-modal'
               id='lightbox'
               title={ this.state.image && this.state.image.title }
               noContainer
        >
            { lightbox }
        </Modal>
    </div>`
