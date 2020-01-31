@ImageGallery = v1 -> React.createClass
  propTypes:
    editable: React.PropTypes.bool
    noFeature: React.PropTypes.bool
    noSquare: React.PropTypes.bool
    imagesPath: React.PropTypes.string
    images: React.PropTypes.array
    onImageClick: React.PropTypes.func
    onImagesLoaded: React.PropTypes.func


  getInitialState: ->
    append: false
    images: @props.images || null

  load: (data, sendCallback=true) ->
    s = images: data

    if @state.images > 0 && data.length > 0
      new_ids = ArrayUtils.pluck(data, 'id')
      old_ids = ArrayUtils.pluck(@state.images, 'id')

      if ArrayUtils.diff(new_ids, old_ids).length == data.length
        s.append = true

    @setState s, @_initialize
    @props.onImagesLoad(data) if @props.onImagesLoad and sendCallback


  componentDidMount: ->
    if @props.imagesPath? and !@props.images
      console.debug '[ImageGallery] Fetching:', @props.imagesPath
      $.get @props.imagesPath, @load
    else
      @_initialize()

    $(window).resize @_resizeJg

  componentWillUnmount: ->
    if @refs.gallery
      $(@refs.gallery).justifiedGallery 'destroy'

    $(window).off 'resize', @_resizeJg

  componentWillReceiveProps: (newProps) ->
    if newProps.images
      @load newProps.images, false

  _resizeJg: ->
    return if @props.noFeature and !@props.noSquare
    if @refs.gallery
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
        Materialize.toast({ html: 'Image moved!', displayLength: 3000, classes: 'green' })
        @load data
      error: (error) =>
        console.log error
      complete: ->
        $(document).trigger 'app:loading:done'

  _handleImageClick: (image) ->
    if @props.onImageClick?
      @props.onImageClick(image.id)
      return true
    return false

  _handleImageChange: (image) ->
    console.debug '[ImageGallery] Lightbox changed image:', image
    StateUtils.updateItem @, 'images', image, 'id'

  _handleImageDelete: (id) ->
    console.debug '[ImageGallery] Lightbox deleted image:', id
    StateUtils.removeItem @, 'images', id, 'id'

  _getJgRowHeight: ->
    coef = if $(window).width() < 900 then 1 else 0.7
    rowHeight: $(window).width() * (coef * 0.25)
    maxRowHeight: $(window).width() * (coef * 0.4)

  _getThumbnailPath: (currentPath, width, height, image) ->
    currentPath ||= ''

    results = currentPath.match(/\d{3}\/\d{3}\/\d{3}\/(\w+)\//)

    if results
      currentSize = results[1]
    else
      currentSize = 'medium'

    max = Math.max(width, height)

    if max <= 427
      newSize = 'small'
    else if max <= 854
      newSize = 'medium'
    else
      newSize = 'large'

    currentPath.replace /(\d{3}\/\d{3}\/\d{3}\/)\w+\//, '$1' + newSize + '/'

  _initialize: ->
    return if @props.noFeature and !@props.noSquare

    if @state.images.length == 0 || !@refs.gallery
      console.debug '[ImageGallery] Empty, no init.'
      return

    if @state.append
      console.debug '[ImageGallery] Init with norewind.'
      try
        $(@refs.gallery).justifiedGallery 'norewind'
      catch e
        console.warn("Attempted to set norewind on an empty gallery.", e)

      return

    console.debug '[ImageGallery] Initializing Justified Gallery...'

    opts =
      selector: '.gallery-image'
      margins: 15
      captions: false
      thumbnailPath: @_getThumbnailPath

    opts = $.extend {}, opts, @_getJgRowHeight()
    $(@refs.gallery).justifiedGallery opts
    @setState append: true


  render: ->
    galleryClassName = 'justified-gallery'
    imageClassName = ''
    wrapperClassName = ''
    _this = @

    imageIds = @state.images?.map (i) ->
      i.id

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
                     gallery={ imageIds }
                     editable={ editable } />`

    if @state.images?.length
      `<div ref='imageGallery' className='image-gallery'>
          { !this.props.noFeature &&
              <GalleryFeature first={ first }
                              second={ second }
                              third={ third }
                              onImageClick={ this._handleImageClick }
                              onImageSwap={ this._handleImageSwap }
                              gallery={ imageIds }
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
