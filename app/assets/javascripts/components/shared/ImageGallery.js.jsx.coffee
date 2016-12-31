@ImageGallery = React.createClass
  componentDidMount: ->
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

        console.log "Swapping #{sourceId} with #{targetId}!"

  render: ->
    `<section className='image-gallery'>
        <div className='container'>
            <div className='row'>
                <div className='col m8 s12'>
                    <div className='image' data-image-id='fox'>
                        <img src='/assets/unsplash/fox.jpg' />
                    </div>
                </div>
                <div className='col m4 s12'>
                    <div className='row'>
                        <div className='col m12 s6'>
                            <div className='image' data-image-id='sand'>
                                <img src='/assets/unsplash/sand.jpg' />
                            </div>
                        </div>
                        <div className='col m12 s6'>
                            <div className='image' data-image-id='boring'>
                                <img src='http://placehold.it/519x321' />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>`
