@Lightbox = React.createClass
  contextTypes:
    router: React.PropTypes.object.isRequired


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
        @state.onDelete(@state.image.id) if @props.onDelete
        Materialize.toast('Image deleted.', 3000, 'green')
        $(document).trigger 'app:image:delete', @state.image.id
        $('#lightbox-delete-form').modal('close')
        $('#lightbox').modal('close')
      error: =>
        Materialize.toast('Could not delete that for some reason.', 3000, 'red')
    e.preventDefault()

  _handleNsfwToggle: (e) ->
    $.ajax
      url: @state.image.path
      type: 'PATCH'
      data: image: nsfw: !@state.image.nsfw
      success: (data) =>
        @setState image: data
        Materialize.toast "Image marked #{(if data.nsfw then 'NSFW' else 'SFW')}.", 3000, 'green'
      error: (data) =>
        console.error data
        Materialize.toast 'NSFW status for this image can not be changed.', 3000, 'red'
    e.preventDefault()

  _handleHiddenToggle: (e) ->
    $.ajax
      url: @state.image.path
      type: 'PATCH'
      data: image: hidden: !@state.image.hidden
      success: (data) =>
        @setState image: data
        console.log data
        Materialize.toast "Image is now #{(if data.hidden then 'hidden' else 'public')}.", 3000, 'green'
      error: (data) =>
        console.error data
        Materialize.toast 'Hidden status for this image can not be changed.', 3000, 'red'
    e.preventDefault()

  handleClose: (e) ->
    if @state.directLoad
      @context.router.push @state.image.character.link
    else
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

        $('#lightbox').modal('open')

  componentDidUpdate: ->
    $('.dropdown-button').dropdown
      constrain_width: false

  render: ->
    if @state.image?
      if @state.image.user_id == @props.currentUser?.username
        imgActions =
          `<div className='image-actions'>
              <ul id='lightbox-image-actions' className='dropdown-content cs-card-background--background-color'>
                  <li><a href='#' onClick={ this.setFeaturedImage }>Set as Cover Image</a></li>
                  <li><a href='#' onClick={ this.setProfileImage }>Set as Profile Image</a></li>

                  <li className='divider' />

                  <li><a href='#image-gravity-modal' className='modal-trigger'>
                      <i className='material-icons left'>crop</i>
                      <span>Cropping...</span>
                  </a></li>

                  <li><a href='#' onClick={ this._handleNsfwToggle }>
                      <i className='material-icons left'>{ this.state.image.nsfw ? 'remove_circle' : 'remove_circle_outline' }</i>
                      <span>{ this.state.image.nsfw ? 'Flagged as NSFW' : 'Flag as NSFW' }</span>
                  </a></li>

                  <li><a href='#' onClick={ this._handleHiddenToggle }>
                      <i className='material-icons left'>{ this.state.image.hidden ? 'visibility_off' : 'visibility' }</i>
                      <span>{ this.state.image.hidden ? 'Private' : 'Public' }</span>
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

        imgGravity =
          `<div className='image-gravity'>
              <select value={ this.state.image.gravity }
                      onChange={ this.handleGravityChange }>
                  <option name='north'>Top</option>
                  <option name='center'>Center</option>
                  <option name='south'>Bottom</option>
                  <option name='west'>Left</option>
                  <option name='east'>Right</option>
              </select>
          </div>`

      lightbox =
        `<div className='lightbox'>
            <div className='image-content'>
                <img src={ this.state.image.url } />

                <a href='#' className='close' onClick={ function(e) { $('#lightbox').modal('close'); e.preventDefault() } }>
                    <i className='material-icons' data-close-lightbox>close</i>
                </a>
            </div>

            <div className='image-details-container'>
                <div className='image-details'>
                    { imgActions }
                    
                    <LightboxCharacterBox character={ this.state.image.character }
                                          postDate={ this.state.image.post_date }
                                          nsfw={ this.state.image.nsfw }
                                          hidden={ this.state.image.hidden } />

                    <RichText className='image-caption'
                              onChange={ captionCallback }
                              content={ this.state.image.caption_html }
                              markup={ this.state.image.caption }
                              placeholder='No caption.' />
                </div>
                
                <div className='comments'>
                </div>
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
                    <a href='#' className='btn red right' onClick={ this.handleDelete } id='image-delete-confirm'>DELETE IMAGE</a>
                    <a href='#' className='btn' onClick={ function(e) { $('#lightbox-delete-form').modal('close'); e.preventDefault() } }>Cancel</a>
                </div>
            </Modal>
        }

        { editable && <ImageGravityModal image={ this.state.image } /> }


        <div className='modal lightbox-modal' id='lightbox'>
            { lightbox }
        </div>
    </div>`
