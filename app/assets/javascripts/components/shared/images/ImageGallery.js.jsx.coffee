@ImageGallery = React.createClass
  propTypes:
    editable: React.PropTypes.bool
    noFeature: React.PropTypes.bool
    noSquare: React.PropTypes.bool
    imagesPath: React.PropTypes.string
    images: React.PropTypes.array
    onImageClick: React.PropTypes.func
    onImagesLoaded: React.PropTypes.func


  getInitialState: ->
    images: @props.images || null

  load: (data, sendCallback=true) ->
    console.debug '[ImageGallery] Loading: ', data
    @setState images: data, @_initialize
    @props.onImagesLoad(data) if @props.onImagesLoad and sendCallback


  componentDidMount: ->
    if @props.imagesPath? and !@props.images
      console.debug '[ImageGallery] Fetching:', @props.imagesPath
      $.get @props.imagesPath, @load

    $(window).resize @_resizeJg

  componentWillUnmount: ->
    $(@refs.gallery).justifiedGallery 'destroy'
    $(window).off 'resize', @_resizeJg

  componentWillReceiveProps: (newProps) ->
    console.debug '[ImageGallery] Loading new props:', newProps.images
    console.debug '[ImageGallery] Replacing old:', @state.images

    if newProps.images
      @load newProps.images, false

  _resizeJg: ->
    $(@refs.gallery).justifiedGallery @_getJgRowHeight()

  _handleImageSwap: (source, target) ->
    # Model.patch "/images/#{source}", (data) =>
    #   Materialize.toast 'Image moved!', 3000, 'green'
    #   @load data

    $(document).trigger 'app:loading'
    $.ajax
      url: '/images/' + source
      type: 'PATCH'
      data: { image: { swap_target_image_id: target } }
      success: (data) =>
        Materialize.toast 'Image moved!', 3000, 'green'
        @load data
      error: (error) =>
        console.log error
      complete: ->
        $(document).trigger 'app:loading:done'

  _handleImageClick: (image) ->
    if @props.onImageClick?
      @props.onImageClick(image.id)
    else
      $(document).trigger 'app:lightbox', image

  _getJgRowHeight: ->
    coef = if $(window).width() < 900 then 1 else 0.7
    rowHeight: $(window).width() * (coef * 0.25)
    maxRowHeight: $(window).width() * (coef * 0.4)

  _initialize: ->
    return if @props.noFeature and !@props.noSquare

    opts =
      selector: '.gallery-image'
      margins: 15
      captions: false

    opts = $.extend {}, opts, @_getJgRowHeight()
    $(@refs.gallery).justifiedGallery opts


  render: ->
    galleryClassName = 'justified-gallery'
    imageClassName = ''
    wrapperClassName = ''
    _this = @

    unless @state.images?
      return `<Spinner />`

    if @props.editable
      editable = true

    if not @props.noFeature
      [first, second, third, overflow...] = @state.images
      imageSize = 'medium'

    else if @props.noSquare
      overflow = @state.images
      imageSize = 'medium'

    else
      galleryClassName = 'row'
      wrapperClassName = 'col s6 m3'
      imageClassName = 'no-jg'
      overflow = @state.images
      imageSize = 'small_square'

    imagesOverflow = overflow.map (image) =>
      `<GalleryImage key={ image.id }
                     image={ image }
                     size={ imageSize }
                     onClick={ _this._handleImageClick }
                     onSwap={ _this._handleImageSwap }
                     wrapperClassName={ wrapperClassName }
                     className={ imageClassName }
                     editable={ editable } />`

    if @state.images?.length
      `<div ref='imageGallery' className='image-gallery'>
          { !this.props.noFeature &&
              <GalleryFeature first={ first }
                              second={ second }
                              third={ third }
                              onImageClick={ this._handleImageClick }
                              onImageSwap={ this._handleImageSwap }
                              editable={ editable } />
          }

          { imagesOverflow.length > 0 &&
              <div ref='gallery' className={ galleryClassName }>
                  { imagesOverflow }
              </div>
          }
      </div>`

    else if @props.edit
      `<div className='image-gallery'>
          <div className='caption center'>Drag and drop images from your computer to your character pages to start a gallery.</div>
      </div>`

    else
      `<div className='image-gallery'>
          <div className='caption center'>This character has not submitted any images</div>
      </div>`
