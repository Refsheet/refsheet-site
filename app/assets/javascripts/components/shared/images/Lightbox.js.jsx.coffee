@Lightbox = React.createClass
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
        Materialize.toast 'Done!', 3000, 'green'
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
        Materialize.toast 'Done!', 3000, 'green'
        $(document).trigger 'app:character:update', data

      error: (error) =>
        console.log error
        Materialize.toast 'Error?', 3000, 'red'

    e.preventDefault()

  handleDelete: (e) ->
    $.ajax
      url: @state.image.path
      type: 'DELETE'
      success: =>
        @state.onDelete(@state.image.id) if @props.onDelete
        Materialize.toast('Image deleted.', 3000, 'green')
        $(document).trigger 'app:image:delete', @state.image.id
        $('#lightbox-delete-form').modal('close')
        $('#lightbox').modal('close')
      error: =>
        Materialize.toast('Could not delete that for some reason.', 3000, 'red')
    e.preventDefault()

  handleClose: (e) ->
    if @state.directLoad
      console.log "Going to #{@state.image.character.link} now..."
      @props.history.push @state.image.character.link
    else
      console.log "Going 'back' now..."
      window.history.back() if @state.image?
    @setState image: null

  componentDidMount: ->
    $('#lightbox').modal
      starting_top: '4%'
      ending_top: '10%'
      complete: (e) =>
        @handleClose(e)

    $(document)
      .on 'click', '[data-image-id]', (e) =>
        $(document).trigger 'app:lightbox', $(e.target).closest('[data-image-id]').data('image-id')
        false
        
      .on 'app:lightbox', (e, imageId) =>
        if typeof imageId != 'object'
          $.ajax
            url: "/images/#{imageId}.json"
            success: (data) =>
              @setState image: data
              window.history.pushState {}, '', data.path

            error: (error) =>
              @setState error: "Image #{error.statusText}"
        else
          @setState image: imageId, directLoad: true
          console.log imageId
          
        $('#lightbox').modal('open')

  render: ->
    if this.state.image?
      if this.state.image.user_id == current_user?.username
        imgActions =
          `<div className='image-actions'>
              <a href='#' onClick={ this.setFeaturedImage }>Set Cover</a>
              <a href='#' onClick={ this.setProfileImage }>Set Profile Image</a>

              <div className='right'>
                  <a href='#lightbox-delete-form' className='modal-trigger'>Delete</a>
              </div>
          </div>`

        captionCallback = @handleCaptionChange
        editable = true

      lightbox =
        `<div className='lightbox'>
            <div className='image-content'>
                <img src={ this.state.image.url } />

                <a href='#' className='close' onClick={ function(e) { $('#lightbox').modal('close'); e.preventDefault() } }>
                    <i className='material-icons' data-close-lightbox>close</i>
                </a>

                { imgActions }
            </div>

            <div className='image-details-container'>
                <div className='image-details'>
                    <LightboxCharacterBox character={ this.state.image.character }
                                          postDate={ this.state.image.post_date } />

                    <RichText className='image-caption'
                              onChange={ captionCallback }
                              content={ this.state.image.caption_html }
                              markup={ this.state.image.caption }
                              placeholder='No caption.' />
                </div>
                
                {/*<div className='comments'>
                    <div className='no-comment'>No Comments</div>
                </div>*/}
            </div>
        </div>`
    else
      lightbox =
        `<div className='loader'>
            {( this.state.error ? <h1>{ this.state.error }</h1> : <Spinner /> )}
        </div>`

    `<div>
        { editable &&
            <Modal id='lightbox-delete-form'>
                <h2>Delete Image</h2>
                <p>Are you sure? This can't be undone.</p>
                <div className='actions margin-top--large'>
                    <a href='#' className='btn red right' onClick={ this.handleDelete }>DELETE IMAGE</a>
                    <a href='#' className='btn' onClick={ function(e) { $('#lightbox-delete-form').modal('close'); e.preventDefault() } }>Cancel</a>
                </div>
            </Modal>
        }

        <div className='modal lightbox-modal' id='lightbox'>
            { lightbox }
        </div>
    </div>`
