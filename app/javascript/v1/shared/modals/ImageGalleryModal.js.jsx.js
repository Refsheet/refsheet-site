@ImageGalleryModal = React.createClass
  handleUploadClick: ->
    this.props.onUploadClick()

  render: ->
    if @props.hideNsfw && @props.images
      images = $.grep @props.images, (i) ->
        !i.nsfw

    else
      images = @props.images

    `<Modal id='image-gallery-modal'
            title={ this.props.title || 'Character Uploads'}
            actions={[
                { name: 'Upload...', action: this.handleUploadClick }
            ]} >

        <div className='card card-panel green darken-3 white-text'>
          <strong>Note:</strong> We're in the process of completely rewriting character profiles, so please pardon
          our dust while we upgrade things. After uploading images to V1 character pages, <strong>you will have to
          reload the page</strong>. <a href='https://refsheet.net/forums/support/uploading-to-v1-profiles' target='_blank'>Here is a forum post</a>{' '}
          explaining things a bit more.
        </div>

        <ImageGallery images={ images }
                      onImageClick={ this.props.onClick }
                      noFeature />
    </Modal>`
