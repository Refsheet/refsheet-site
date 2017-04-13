@ImageGalleryModal = React.createClass
  handleUploadClick: ->
    $('.dz-hidden-input').click()

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

        <ImageGallery images={ images }
                      onImageClick={ this.props.onClick }
                      noFeature />
    </Modal>`
