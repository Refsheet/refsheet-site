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


  componentDidMount: ->
    if @props.imagesPath? and !@props.images
      $.get @props.imagesPath, (data) =>
        @setState images: data, =>
          $(@refs.imageGallery).imagesLoaded @_initialize
        @props.onImagesLoad(data) if @props.onImagesLoad

  componentWillReceiveProps: (newProps) ->
    if newProps.images && newProps.images.length != @state.images?.length
      @setState images: newProps.images, =>
        $(@refs.imageGallery).imagesLoaded @_initialize


  _initialize: ->
    return if @props.noFeature

    width = (selector) =>
      $(@refs.imageGallery).find(selector).width()

    height = (selector) =>
      $(@refs.imageGallery).find(selector).height()

    ratio = (selector) =>
      height(selector) / width(selector)

    g = 15
    x0 = width '.gallery-feature'
    r1 = ratio '.feature-main'
    r2 = ratio '.side-image.top'
    r3 = ratio '.side-image.bottom'

    # Lots of magic. Ask Wolfram Alpha.
    t = g - g*r2 - g*r3 + r2*x0 + r3*x0
    b = r1 + r2 + r3
    x1 = t / b
    x2 = x0 - x1 - g

    console.log
      x0: x0
      r1: r1
      r2: r2
      r3: r3
      x1: x1
      x2: x2

    $(@refs.featureMain).css
      width: x1

    $(@refs.featureSide).css
      width: x2

    $(@refs.gallery).justifiedGallery
      selector: '.gallery-image'
      margins: 15
      rowHeight: 200

  _handleImageSwap: (source, target) ->
    $.ajax
      url: '/images/' + source
      type: 'PATCH'
      data: { image: { swap_target_image_id: target } }
      success: (data) =>
        Materialize.toast 'Image moved!', 3000, 'green'
      error: (error) =>
        console.log error

  _handleImageClick: (image) ->
    if @props.onImageClick?
      @props.onImageClick(image.id)
    else
      $(document).trigger 'app:lightbox', image


  render: ->
    unless @state.images?
      return `<Spinner />`

    if @props.editable
      editable = true

    unless @props.noFeature
      [first, second, third, overflow...] = @state.images
    else
      overflow = @state.images

    imagesOverflow = overflow.map (image) ->
      `<GalleryImage key={ image.id }
                     image={ image }
                     size='small'
                     onClick={ this._handleImageClick }
                     onSwap={ this._handleImageSwap }
                     editable={ editable } />`

    if @state.images?.length
      `<div ref='imageGallery' className='image-gallery'>
          { !this.props.noFeature &&
              <div ref='galleryFeature' className='gallery-feature'>
                  <div ref='featureMain' className='feature-left'>
                      <GalleryImage className='feature-main'
                                    image={ first }
                                    size='large'
                                    onClick={ this._handleImageClick }
                                    onSwap={ this._handleImageSwap }
                                    editable={ editable } />
                  </div>

                  <div ref='featureSide' className='feature-side'>
                      <GalleryImage className='side-image top'
                                    image={ second }
                                    size='medium'
                                    onClick={ this._handleImageClick }
                                    onSwap={ this._handleImageSwap }
                                    editable={ editable } />

                      <GalleryImage className='side-image bottom'
                                    image={ third }
                                    size='medium'
                                    onClick={ this._handleImageClick }
                                    onSwap={ this._handleImageSwap }
                                    editable={ editable } />
                  </div>
              </div>
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
