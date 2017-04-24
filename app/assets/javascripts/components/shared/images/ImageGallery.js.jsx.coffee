@ImageGallery = React.createClass
  propTypes:
    editable: React.PropTypes.bool
    noFeature: React.PropTypes.bool
    imagesPath: React.PropTypes.string
    images: React.PropTypes.array
    onImageClick: React.PropTypes.func
    onImagesLoaded: React.PropTypes.func


  getInitialState: ->
    images: @props.images || null

  load: (data) ->
    @setState images: data, @_initialize
    @props.onImagesLoad(data) if @props.onImagesLoad


  componentDidMount: ->
    if @props.imagesPath? and !@props.images
      $.get @props.imagesPath, @load


  componentWillReceiveProps: (newProps) ->
    if newProps.images && newProps.images.length != @state.images?.length
      @load newProps.images


  _handleImageSwap: (source, target) ->
    console.log source, target

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

  _initialize: ->
    $(@refs.gallery).justifiedGallery
      selector: '.gallery-image'
      margins: 15
      rowHeight: 250
      maxHeight: 350
      captions: false


  render: ->
    unless @state.images?
      return `<Spinner />`

    if @props.editable
      editable = true

    unless @props.noFeature
      [first, second, third, overflow...] = @state.images
    else
      overflow = @state.images

    imagesOverflow = overflow.map (image) =>
      `<GalleryImage key={ image.id }
                     image={ image }
                     size='small'
                     onClick={ _this._handleImageClick }
                     onSwap={ _this._handleImageSwap }
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
              <div ref='gallery' className='justified-gallery'>
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
