@ImageGallery = React.createClass
  getInitialState: ->
    images: @props.images || null

  handleImageSwap: (source, target) ->
    $.ajax
      url: '/images/' + source
      type: 'PATCH'
      data: { image: { swap_target_image_id: target } }
      success: (data) =>
        Materialize.toast 'Image moved!', 3000, 'green'
      error: (error) =>
        console.log error

  handleImageClick: (e) ->
    id = $(e.target).closest('[data-gallery-image-id]').data('gallery-image-id')

    if @props.onImageClick?
      @props.onImageClick(id)
    else
      $(document).trigger 'app:lightbox', id

  componentDidMount: ->
    if @props.imagesPath?
      if @props.images?
        @setupImageOrder()
      else
        $.get @props.imagesPath, (data) =>
          @setState images: data

  componentDidUpdate: (newProps) ->
    if newProps.images.length != @state.images.length
      @setState images: newProps.images

    if @props.imagesPath?
      @setupImageOrder()

  setupImageOrder: ->
    if @props.editable
      _this = this
      $('.image-gallery .image').draggable
        revert: true
        opacity: 0.6

      $('.image-gallery .image').droppable
        drop: (event, ui) ->
          $source = ui.draggable
          $sourceParent = $source.parent()
          $target = $(this)
          $targetParent = $target.parent()

          $targetParent.append $source
          $sourceParent.append $target

          $source.css top: '', left: '0'

          sourceId = $source.data 'image-id'
          targetId = $target.data 'image-id'

          _this.handleImageSwap(sourceId, targetId)

  render: ->
    unless @state.images?
      return `<Spinner />`

    unless @props.noFeature
      [first, second, third, overflow...] = @state.images
    else
      overflow = @state.images

    imagesOverflow = overflow.map (image) =>
      `<div className='col m3 s6' key={ image.id }>
          <div className='image' data-gallery-image-id={ image.id }>
              <img src={ image.small } alt={ image.caption } />
          </div>
      </div>`

    if first? or imagesOverflow.length > 0
      if first?
        firstColWidth = 12
        firstImage =
          `<div className='image' data-gallery-image-id={ first.id }>
              <img src={ first.url } alt={ first.caption } />
          </div>`

      if third?
        thirdImage =
          `<div className='image' data-gallery-image-id={ third.id }>
              <img src={ third.medium } alt={ third.caption } />
          </div>`

      if second?
        firstColWidth = 8
        secondImage =
          `<div className='image' data-gallery-image-id={ second.id }>
              <img src={ second.medium } alt={ second.caption } />
          </div>`

        secondColumn =
          `<Column m={4}>
              <Row className='featured-side'>
                  <Column m={12} s={6}>
                      { secondImage }
                  </Column>
                  <Column m={12} s={6}>
                      { thirdImage }
                  </Column>
              </Row>
          </Column>`

      `<div className='image-gallery' onClick={ this.handleImageClick }>
          { !this.props.noFeature &&
              <Row className='featured'>
                  <Column m={ firstColWidth }>
                      { firstImage }
                  </Column>
                  { secondColumn }
              </Row>
          }

          { imagesOverflow.length > 0 &&
              <Row className='gallery-grid'>{ imagesOverflow }</Row>
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
