@Lightbox = React.createClass
  getInitialState: ->
    image: null
    error: null

  handleClose: (e) ->
    if $(e.target).data('close-lightbox')
      @props.onClose()
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
      character =
        `<div className='character'>
            <div className='avatar'>
            </div>
            <div className='name'>
                Akhet
            </div>
        </div>`

      lightbox =
        `<div className='lightbox'>
            <div className='image-content'>
                <img src={ this.state.image.url } />
            </div>

            <div className='image-details-container'>
                <div className='image-details'>
                    { character }
                    <p className='caption'>
                        { this.state.image.caption || <div className='no-caption'>No caption.</div> }
                    </p>
                </div>
                
                <div className='comments'>
                    Comments?
                </div>
                
                <div className='actions'>
                    <input type='text' placeholder='Add Comment...' />
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
