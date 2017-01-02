@Lightbox = React.createClass
  getInitialState: ->
    image: null
    error: null

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

  componentDidMount: ->
    $.ajax
      url: "/images/#{@props.imageId}"
      type: 'GET'
      success: (data) =>
        @setState image: data

      error: (error) =>
        @setState error: "Image #{error.statusText}"

  render: ->
    if this.state.image?
      lightbox =
        `<div className='lightbox'>
            <div className='image-content'>
                <img src={ this.state.image.url } />

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
