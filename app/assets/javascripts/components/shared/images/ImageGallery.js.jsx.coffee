@ImageGallery = React.createClass
  getInitialState: ->
    images: @props.images || null

  handleImageSwap: (source, target) ->
    $.ajax
      url: @props.imagesPath + source
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
    $.get @props.imagesPath, (data) =>
      @setState images: data

  componentDidUpdate: ->
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
    if @state.images?
      images = @state.images.map (image) =>
        `<div className='col m3 s6' key={ image.id }>
            <div className='image' data-image-id={ image.id }>
                <img src={ image.url } alt={ image.caption } />
            </div>
        </div>`

    else
      images = `<Spinner />`

    `<section className='image-gallery'>
        <div className='container'>
            <div className='row' onClick={ this.handleImageClick }>
                { images }
            </div>
        </div>
    </section>`
