@ImageGallery = React.createClass
  getInitialState: ->
    images: @props.images || null

  handleImageSwap: (source, target) ->
    $.ajax
      url: '/images/' + source
      type: 'PATCH'
      data: { image: { swap_target_image_id: target } }
    , (data) =>
      @setState images: data
    , (error) =>
      console.log error

  handleImageClick: (e) ->
    id = $(e.target).closest('[data-image-id]').data('image-id')
    @props.onImageClick(id) if @props.onImageClick?

  componentDidMount: ->
    if !@props.images?
      @setupImageOrder()
    else
      $.get @props.imagesPath, (data) =>
        @setState images: data

  componentDidUpdate: ->
    @setupImageOrder()

  setupImageOrder: ->
    if @props.edit
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

    [first, second, third, overflow...] = @state.images

    imagesOverflow = overflow.map (image) =>
      `<div className='col m3 s6' key={ image.id }>
          <div className='image' data-image-id={ image.id }>
              <img src={ image.small } alt={ image.caption } />
          </div>
      </div>`

    if first?
      firstColWidth = 12
      firstImage =
        `<div className='image' data-image-id={ first.id }>
            <img src={ first.url } alt={ first.caption } />
        </div>`

      if third?
        thirdImage =
          `<div className='image' data-image-id={ third.id }>
              <img src={ third.medium } alt={ third.caption } />
          </div>`

      if second?
        firstColWidth = 8
        secondImage =
          `<div className='image' data-image-id={ second.id }>
              <img src={ second.medium } alt={ second.caption } />
          </div>`

        secondColumn =
          `<Column m={4}>
              <Row>
                  <Column m={12} s={6}>
                      { secondImage }
                  </Column>
                  <Column m={12} s={6}>
                      { thirdImage }
                  </Column>
              </Row>
          </Column>`

      `<section className='image-gallery'>
          <div className='container' onClick={ this.handleImageClick }>
              <Row className='featured'>
                  <Column m={ firstColWidth }>
                      { firstImage }
                  </Column>
                  { secondColumn }
              </Row>
              <Row>{ imagesOverflow }</Row>
          </div>
      </section>`

    else if @props.edit
      `<Section className='image-gallery'>
          <div className='caption center'>Drag and drop images from your computer to your character pages to start a gallery.</div>
      </Section>`

    else
      `<Section className='image-gallery'>
          <div className='caption center'>This character has not submitted any images</div>
      </Section>`
