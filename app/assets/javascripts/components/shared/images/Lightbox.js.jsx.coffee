@Lightbox = React.createClass
  getInitialState: ->
    if typeof @props.imageId == 'object'
      image: @props.imageId
      error: null
      directLoad: true
    else
      image: null
      error: null
      directLoad: false

  handleClose: (e) ->
    if $(e.target).data('close-lightbox')
      @props.onClose()
      e.preventDefault()

  setFeaturedImage: (e) ->
    $.ajax
      url: @state.image.character.path
      type: 'PATCH'
      data: { character: { featured_image_guid: @state.image.id } }
      success: (data) =>
        Materialize.toast 'Done!', 3000, 'green'

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

      error: (error) =>
        console.log error
        Materialize.toast 'Error?', 3000, 'red'

    e.preventDefault()

  componentWillMount: ->
    $('body').addClass('lightbox-open')

  componentWillUnmount: ->
    $('body').removeClass('lightbox-open')

    if @state.directLoad
      console.log "Going to #{@state.image.character.path} now..."
      @props.history.push @state.image.character.path
    else
      console.log "Going 'back' now..."
      window.history.back() if @state.image?

  componentDidMount: ->
    unless @state.image?
      $.ajax
        url: "/images/#{@props.imageId}.json"
        type: 'GET'
        success: (data) =>
          @setState image: data
          window.history.pushState {}, data.caption, data.path

        error: (error) =>
          @setState error: "Image #{error.statusText}"

  render: ->
    if this.state.image?
      lightbox =
        `<div className='lightbox'>
            <div className='image-content'>
                <img src={ this.state.image.url } />

                <a href='#' className='close' data-close-lightbox>
                    <i className='material-icons' data-close-lightbox>close</i>
                </a>

                <div className='image-actions'>
                    <a href='#' onClick={ this.setFeaturedImage }>Set Cover</a>
                    <a href='#' onClick={ this.setProfileImage }>Set Profile Image</a>

                    <div className='right'>
                        <a href='#'>Delete</a>
                    </div>
                </div>
            </div>

            <div className='image-details-container'>
                <div className='image-details'>
                    <LightboxCharacterBox character={ this.state.image.character } />

                    <p className='caption'>
                        { this.state.image.caption || <div className='no-caption'>No caption.</div> }
                    </p>
                </div>
                
                <div className='comments'>
                    <div className='no-comment'>No Comments</div>
                </div>
            </div>
        </div>`
    else
      lightbox =
        `<div className='loader'>
            {( this.state.error ? <h1>{ this.state.error }</h1> : <Spinner /> )}
        </div>`

    `<div className='lightbox-container' onClick={ this.handleClose } data-close-lightbox>
        { lightbox }
    </div>`
