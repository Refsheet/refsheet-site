import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Dropzone from 'react-dropzone'
import Filmstrip from './Filmstrip'
import UploadForm from './UploadForm'
import ImageHandler from 'ImageHandler'

class UploadModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      pendingImages: [],
      activeImageId: null
    }

    this.counter = 0

    this.handleImageDrop = this.handleImageDrop.bind(this)
    this.setActiveImage = this.setActiveImage.bind(this)
    this.handleImageChange = this.handleImageChange.bind(this)
    this.handleUpload = this.handleUpload.bind(this)
  }

  componentDidMount() {
    $('#upload-images').modal('open')
  }

  handleImageDrop(acceptedFiles, rejectedFiles) {
    let { activeImageId } = this.state

    acceptedFiles.forEach((file) => {
      const pending = this.state.pendingImages

      console.log("PENDING", pending.length)

      const filename = file.name
          .replace(/\..*?$/, '')
          .replace(/[-_]+/g, ' ')
          .replace(/\s+/, ' ')

      const image = {
        id: this.counter++,
        title: filename,
        folder: 'default',
        nsfw: false,
        state: 'pending',
        progress: 0
      }

      Object.assign(file, image)

      if(!activeImageId && activeImageId !== 0) activeImageId = image.id

      pending.push(file)
      this.setState({pendingImages: pending, activeImageId})
    })

    rejectedFiles.forEach((file) => {
      Materialize.toast(file.name + ' is invalid.', 3000, 'red')
    })
  }

  setActiveImage(activeImageId) {
    console.log("Setting active", activeImageId)
    this.setState({activeImageId})
  }

  getActiveImage() {
    return this.state.pendingImages.filter((i) => i.id === this.state.activeImageId)[0]
  }

  removeImage(imageId) {
    let { selectedIndex } = this.state
    const pendingImages = this.state.pendingImages
        .filter((i) => i.id !== imageId)

    if (pendingImages.length <= selectedIndex)
      selectedIndex = pendingImages.length - 1

    this.setState({pendingImages, selectedIndex})
  }

  selectNextImage() {
    const currentIndex = this.state.pendingImages.indexOf(this.getActiveImage()) || 0
    let selectedIndex = 0

    if (currentIndex >= 0 && currentIndex !== (this.state.pendingImages.length - 1)) {
      selectedIndex = currentIndex + 1
    }

    return this.setActiveImage(this.state.pendingImages[selectedIndex].id)
  }

  handleImageChange(newImage) {
    const newImages = this.state.pendingImages.map((image) => {
      if(image.id === newImage.id) {
        Object.assign(image, newImage)
      }

      return image
    })

    this.setState({pendingImages: newImages})
  }

  handleUpload(image) {
    image.state = 'uploading'
    this.handleImageChange(image)

    ImageHandler
        .upload(image, this.props.characterId, this.handleImageChange)
        .then((image) => {
          Materialize.toast(image.title + ' uploaded!', 3000, 'green')
          this.removeImage(image.id)
          this.props.onUpload(image)
        })

    this.selectNextImage()
  }

  renderPending(images) {
    const imageArray = images.map((image) => {
      const { state, progress } = image
      return { src: image.preview, id: image.id, state, progress }
    })

    return <Filmstrip
        images={imageArray}
        autoHide
        activeImageId={this.state.activeImageId}
        onSelect={this.setActiveImage}
    />
  }

  renderCurrent(image) {
    if(!image) return null

    return <div className='image-preview' style={{display: 'flex'}}>
      <div className='image-container' style={{backgroundColor: 'black', textAlign: 'center', flexGrow: 1, overflow: 'hidden'}}>
        <img src={image.preview} height={300} style={{display: 'inline-block', verticalAlign: 'middle'}}/>
        { image.state === 'error' &&
          <div className='upload-error red darken-4 white-text padding--small'><strong>Error:</strong> { image.errorMessage }</div> }
      </div>

      <UploadForm image={image} onChange={this.handleImageChange} onUpload={this.handleUpload} />
    </div>
  }

  render() {
    const activeImage = this.getActiveImage()

    let title = 'Upload Images'

    if(activeImage) {
      let status = 'Upload'

      if(activeImage.state === 'uploading') {
        status = `Uploading (${activeImage.progress}%)`
      }

      title = `${status}: ${activeImage.title || activeImage.name}`
    }

    return (
      <Modal id='upload-images' title={title} noContainer onClose={this.props.onClose}>
        { this.state.pendingImages.length === 0 &&
        <Dropzone onDrop={this.handleImageDrop} accept='image/*'>
          <div className='modal-content'>
            <p>Click here or drag and drop images to upload.</p>
          </div>
        </Dropzone> }

        { this.renderCurrent(activeImage) }
        { this.renderPending(this.state.pendingImages) }
      </Modal>
    )
  }
}

UploadModal.propTypes = {
  characterId: PropTypes.string,
  onUpload: PropTypes.func
}

export default UploadModal
