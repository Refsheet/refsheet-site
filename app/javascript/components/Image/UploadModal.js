import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Filmstrip from './Filmstrip'
import UploadForm from './UploadForm'
import ImageHandler from 'ImageHandler'
import {clearUpload, closeUploadModal, modifyUpload} from "../../actions";
import {connect} from "react-redux";
import M from 'materialize-css'

class UploadModal extends Component {
  constructor(props, context) {
    super(props, context)
    let activeImageId = null

    if (this.props.files.length > 0) {
      activeImageId = this.props.files[0].id
    }

    this.state = {
      activeImageId
    }

    this.setActiveImage = this.setActiveImage.bind(this)
    this.handleImageChange = this.handleImageChange.bind(this)
    this.handleUpload = this.handleUpload.bind(this)
    this.handleUploadClick = this.handleUploadClick.bind(this)
    this.handleImageClear = this.handleImageClear.bind(this)
  }

  componentDidMount() {
    M.Modal.getInstance(document.getElementById('upload-images')).open()
  }

  componentDidUpdate(prevProps) {
    if (this.props.files.length > prevProps.files.length && this.state.activeImageId === null) {
      const activeImageId = this.props.files[0].id
      this.setState({activeImageId})
    } else if (this.props.files.length < prevProps.files.length) {
      this.selectNextImage()
    }

    if (prevProps.activeImageId !== this.props.activeImageId) {
      this.setActiveImage(this.props.activeImageId)
    }
  }

  setActiveImage(activeImageId) {
    console.log("Setting active", activeImageId)
    this.setState({activeImageId})
  }

  getActiveImage() {
    return this.props.files.filter((i) => i.id === this.state.activeImageId)[0]
  }

  selectNextImage() {
    if (this.props.files.length === 0) {
      console.log("Clearing active image.")
      return this.setActiveImage(null)
    }

    const currentIndex = this.props.files.indexOf(this.getActiveImage()) || 0
    let selectedIndex = 0

    if (currentIndex >= 0 && currentIndex !== (this.props.files.length - 1)) {
      selectedIndex = currentIndex + 1
    }

    return this.setActiveImage(this.props.files[selectedIndex].id)
  }

  handleImageChange(newImage) {
    this.props.modifyUpload(newImage);
  }

  handleImageClear(imageId) {
    this.props.clearUpload(imageId)
    this.selectNextImage()
  }

  handleUploadClick(e) {
    e.preventDefault()

    const dz = this.context.getDropzone && this.context.getDropzone()

    if (dz) {
      dz.open()
    }
  }

  handleUpload(image) {
    image.state = 'uploading'
    this.handleImageChange(image)

    ImageHandler
        .upload(image, this.props.characterId, this.handleImageChange)
        .then((image) => {
          Materialize.toast(image.title + ' uploaded!', 3000, 'green')
          this.props.clearUpload(image.id)
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

      <UploadForm image={image} onChange={this.handleImageChange} onUpload={this.handleUpload} onClear={this.handleImageClear} />
    </div>
  }

  renderPlaceholder() {
    if (this.props.files.length !== 0) {
      return null
    }

    return <div className={'modal-content'} style={{textAlign: 'center'}}>
      <i className={'material-icons'} style={{fontSize: '3rem'}}>cloud_upload</i>
      <p className={'caption'}>Drag & Drop to upload files.</p>
      <button className={'btn'} type={'button'} onClick={this.handleUploadClick}>Select Files</button>
    </div>
  }

  handleClose() {
    if (this.props.onClose) {
      this.props.onClose()
    } else {
      this.props.closeUploadModal()
    }
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
      <Modal id='upload-images' title={title} noContainer onClose={this.handleClose.bind(this)}>
        { this.renderCurrent(activeImage) }
        { this.renderPending(this.props.files) }
        { this.renderPlaceholder() }
      </Modal>
    )
  }
}

UploadModal.propTypes = {
  characterId: PropTypes.string,
  onUpload: PropTypes.func,
  alwaysOpen: PropTypes.bool,
  activeImageId: PropTypes.string
}

UploadModal.contextTypes = {
  getDropzone: PropTypes.func
}

const mapStateToProps = ({uploads}, props) => ({
  files: uploads.files,
  characterId: uploads.characterId,
  modalOpen: uploads.modalOpen,
  activeImageId: uploads.activeImageId,
  ...props
})

const mapDispatchToProps = {
  clearUpload,
  modifyUpload,
  closeUploadModal
}

const Wrapped = (props) => {
  const {
    alwaysOpen = false,
    modalOpen = false
  } = props

  if (!alwaysOpen && !modalOpen) {
    return null
  }

  return <UploadModal {...props} />
}

export default connect(mapStateToProps, mapDispatchToProps, null, {pure: false})(Wrapped)
