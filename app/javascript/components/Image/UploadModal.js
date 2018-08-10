import React, { Component } from 'react'
import Dropzone from 'react-dropzone'
import Filmstrip from './Filmstrip'

class UploadModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      pendingImages: [],
      activeImage: undefined
    }

    this.handleImageDrop = this.handleImageDrop.bind(this)
    this.setActiveImage = this.setActiveImage.bind(this)
  }

  componentDidMount() {
    $('#upload-images').modal('open')
  }

  handleImageDrop(acceptedFiles, rejectedFiles) {
    acceptedFiles.forEach((file) => {
      const image = new Image

      image.addEventListener('load', () => {
        const pending = this.state.pendingImages
        file.width = image.naturalWidth
        file.height = image.naturalHeight
        pending.push(file)
        console.log(file)
        this.setState({pendingImages: pending})
      })

      image.src = file.preview
    })
  }

  setActiveImage(activeImageId) {
    const image = this.state.pendingImages[activeImageId]
    this.setState({activeImage: image})
  }

  renderPending(images) {
    const imageArray = images.map((image, i) => {
      return { src: image.preview, id: i }
    })

    return <Filmstrip images={imageArray}
                      autoHide
                      onSelect={this.setActiveImage} />
  }

  render() {
    const {
      character = {}
    } = this.props

    const {
      activeImage
    } = this.state

    const uploadUrl = `/users/${character.username}/characters/${character.slug}/images`

    let title = 'Upload Images'

    if(activeImage) {
      title = `Upload: ${activeImage.name}`
    }

    return (
      <Modal id='upload-images' title={title} noContainer>
        <Dropzone onDrop={this.handleImageDrop} accept='image/*'>
          <div className='modal-content'>
            <p>Click here or drag and drop images to upload.</p>
          </div>
        </Dropzone>

        { this.renderPending(this.state.pendingImages) }
      </Modal>
    )
  }
}

UploadModal.propTypes = {

}

export default UploadModal
