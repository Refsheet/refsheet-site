@ImageGalleryModal = React.createClass
  handleUploadClick: ->
    $('.dz-hidden-input').click()

  render: ->
    `<Modal id='image-gallery-modal'
            title={ this.props.title || 'Character Uploads'}
            actions={[
                { name: 'Upload...', action: this.handleUploadClick }
            ]} >

        <ImageGallery images={ this.props.images }
                      onImageClick={ this.props.onClick }
                      noFeature />
    </Modal>`
