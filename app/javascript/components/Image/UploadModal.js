import React, { Component } from 'react'
import Dropzone from 'react-dropzone'
import Filmstrip from './Filmstrip'
import UploadForm from './UploadForm'

class UploadModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      pendingImages: [],
      activeImageId: undefined
    }

    this.counter = 0

    this.handleImageDrop = this.handleImageDrop.bind(this)
    this.setActiveImage = this.setActiveImage.bind(this)
    this.handleImageChange = this.handleImageChange.bind(this)
  }

  componentDidMount() {
    $('#upload-images').modal('open')
  }

  handleImageDrop(acceptedFiles, rejectedFiles) {
    acceptedFiles.forEach((file) => {
      const pending = this.state.pendingImages

      const filename = file.name
          .replace(/\..*?$/, '')
          .replace(/[-_]+/g, ' ')
          .replace(/\s+/, ' ')

      Object.assign(file, {
        id: this.counter++,
        title: filename,
        folder: 'default',
        nsfw: false,
        state: 'pending',
        progress: 0,
      })

      pending.push(file)
      this.setState({pendingImages: pending})
    })

    rejectedFiles.forEach((file) => {
      Materialize.toast(file.name + ' is invalid.', 3000, 'red')
    })
  }

  setActiveImage(activeImageId) {
    this.setState({activeImageId})
  }

  getActiveImage() {
    return this.state.pendingImages.filter((i) => i.id === this.state.activeImageId)[0]
  }

  handleImageChange(newImage) {
    console.log(newImage)
    const newImages = this.state.pendingImages.map((image) => {
      if(image.id === newImage.id) {
        Object.assign(image, newImage)
      }

      return image
    })

    this.setState({pendingImages: newImages})
  }

  renderPending(images) {
    const imageArray = images.map((image, i) => {
      return { src: image.preview, id: i }
    })

    return <Filmstrip
        images={imageArray}
        autoHide
        onSelect={this.setActiveImage}
    />
  }

  renderCurrent(image) {
    if(!image) return null

    return <div className='image-preview' style={{display: 'flex'}}>
      <div className='image-container' style={{backgroundColor: 'black', textAlign: 'center', flexGrow: 1, overflow: 'hidden'}}>
        <img src={image.preview} height={300} style={{display: 'inline-block', verticalAlign: 'middle'}}/>
      </div>

      <UploadForm image={image} onChange={this.handleImageChange} />
    </div>
  }

  render() {
    const activeImage = this.getActiveImage()

    let title = 'Upload Images'

    if(activeImage) {
      let status = 'Upload'

      if(activeImage.status !== 'pending') {
        status = `Uploading (${activeImage.progress}%)`
      }

      title = `${status}: ${activeImage.title || activeImage.name}`
    }

    return (
      <Modal id='upload-images' title={title} noContainer>
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

}

export default UploadModal
