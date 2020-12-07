import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Filmstrip from './Filmstrip'
import UploadForm from './UploadForm'
import ImageHandler from 'ImageHandler'
import { clearUpload, closeUploadModal, modifyUpload } from '../../actions'
import { connect } from 'react-redux'
import c from 'classnames'
import { Query } from 'react-apollo'
import getCharacterForUpload from './getCharacterForUpload.graphql'
import IdentityModal from '../Shared/CommentForm/IdentityModal'
import { withTranslation } from 'react-i18next'
import compose from '../../utils/compose'
import * as Materialize from 'materialize-css'

import Icon from 'v1/shared/material/Icon'
import Modal from 'v1/shared/Modal'
import { withErrorBoundary } from '../Shared/ErrorBoundary'

class UploadModal extends Component {
  constructor(props, context) {
    super(props, context)
    let activeImageId = null

    if (this.props.files.length > 0) {
      activeImageId = this.props.files[0].id
    }

    this.state = {
      activeImageId,
      characterId: this.props.characterId,
      identityModalOpen: false,
    }

    this.setActiveImage = this.setActiveImage.bind(this)
    this.handleImageChange = this.handleImageChange.bind(this)
    this.handleUpload = this.handleUpload.bind(this)
    this.handleUploadClick = this.handleUploadClick.bind(this)
    this.handleImageClear = this.handleImageClear.bind(this)
  }

  componentDidUpdate(prevProps) {
    if (
      this.props.files.length > prevProps.files.length &&
      this.state.activeImageId === null
    ) {
      const activeImageId = this.props.files[0].id
      this.setState({ activeImageId })
    } else if (this.props.files.length < prevProps.files.length) {
      this.selectNextImage()
    }

    if (prevProps.activeImageId !== this.props.activeImageId) {
      this.setActiveImage(this.props.activeImageId)
    }

    if (prevProps.characterId !== this.props.characterId) {
      this.setCharacter({ id: this.props.characterId })
    }
  }

  setCharacter(character) {
    this.setState({ characterId: character.id, identityModalOpen: false })
    console.debug('setCharacter(' + this.state.characterId + ')')
  }

  handleChangeCharacterClick(e) {
    e.preventDefault()
    this.setState({ identityModalOpen: true })
  }

  handleIdentityClose() {
    this.setState({ identityModalOpen: false })
  }

  setActiveImage(activeImageId) {
    this.setState({ activeImageId })
  }

  getActiveImage() {
    return this.props.files.filter(i => i.id === this.state.activeImageId)[0]
  }

  selectNextImage() {
    if (this.props.files.length === 0) {
      console.debug('Clearing active image.')
      return this.setActiveImage(null)
    }

    const currentIndex = this.props.files.indexOf(this.getActiveImage()) || 0
    let selectedIndex = 0

    if (currentIndex >= 0 && currentIndex !== this.props.files.length - 1) {
      selectedIndex = currentIndex + 1
    }

    return this.setActiveImage(this.props.files[selectedIndex].id)
  }

  handleImageChange(newImage) {
    this.props.modifyUpload(newImage)
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

    ImageHandler.upload(
      image,
      this.state.characterId,
      this.handleImageChange.bind(this)
    )
      .then(image => {
        Materialize.toast({
          html: image.title + ' uploaded!',
          displayLength: 3000,
          classes: 'green',
        })
        this.props.clearUpload(image.id)
        this.props.onUpload && this.props.onUpload(image)
        this.props.uploadCallback && this.props.uploadCallback(image)
      })
      .catch(console.log)

    this.selectNextImage()
  }

  renderPending(images) {
    const imageArray = images.map(image => {
      const { state, progress } = image
      return { src: image.preview, id: image.id, state, progress }
    })

    return (
      <Filmstrip
        images={imageArray}
        autoHide
        activeImageId={this.state.activeImageId}
        onSelect={this.setActiveImage}
      />
    )
  }

  renderCurrent(image, character) {
    if (!image) return null

    return (
      <div className="image-preview" style={{ display: 'flex' }}>
        <div
          className="image-container"
          style={{
            backgroundColor: 'black',
            textAlign: 'center',
            flexGrow: 1,
            overflow: 'hidden',
          }}
        >
          <img
            src={image.preview}
            height={300}
            style={{ display: 'inline-block', verticalAlign: 'middle' }}
          />
          {image.state === 'error' && (
            <div className="upload-error red darken-4 white-text padding--small">
              <strong>Error:</strong> {image.errorMessage}
            </div>
          )}
        </div>

        <UploadForm
          image={image}
          character={character}
          characterId={this.state.characterId}
          onChange={this.handleImageChange}
          onUpload={this.handleUpload}
          onClear={this.handleImageClear}
          onCharacterChangeClick={this.handleChangeCharacterClick.bind(this)}
        />
      </div>
    )
  }

  renderPlaceholder() {
    if (this.props.files.length !== 0) {
      return null
    }

    return (
      <div className={'modal-content'} style={{ textAlign: 'center' }}>
        <i className={'material-icons'} style={{ fontSize: '3rem' }}>
          cloud_upload
        </i>
        <p className={'caption'}>Drag & Drop to upload files.</p>
        <button
          className={'btn'}
          type={'button'}
          onClick={this.handleUploadClick}
        >
          Select Files
        </button>
      </div>
    )
  }

  renderCharacterTarget(character, loading, error) {
    const { t } = this.props

    let characterName = t(
      'identity.no_character_selected',
      'No Character Selected'
    )

    if (loading) {
      characterName = t('status.loading', 'Loading...')
    } else if (character && character.name) {
      characterName = character.name
    }

    return (
      <div
        className={c('modal-notice', 'character-select', { alert: !character })}
      >
        {t('actions.upload_to', 'Upload To')}: <strong>{characterName}</strong>
        {error && (
          <div className={'red-text'}>
            {error.message || JSON.stringify(error)}
          </div>
        )}
        {!loading && (
          <a
            className={'right btn-flat'}
            href={'#'}
            onClick={this.handleChangeCharacterClick.bind(this)}
            title={t('actions.change_character', 'Change Character...')}
          >
            <Icon className={'left'}>swap_horiz</Icon> Change
          </a>
        )}
      </div>
    )
  }

  handleClose() {
    if (this.props.onClose) {
      this.props.onClose()
    } else {
      this.props.closeUploadModal()
    }
  }

  render() {
    const { t } = this.props

    const activeImage = this.getActiveImage()

    let title = t('actions.upload_images', 'Upload Images')

    if (activeImage) {
      let status = t('actions.upload', 'Upload')

      if (activeImage.state === 'uploading') {
        status = t(
          'actions.uploading_with_progress',
          'Uploading {{progress}}%',
          { progress: activeImage.progress }
        )
      }

      title = `${status}: ${activeImage.title || activeImage.name}`
    }

    return (
      <Query
        query={getCharacterForUpload}
        variables={{ id: this.state.characterId }}
      >
        {({ data, loading, error, ...props }) => {
          const getCharacter = data && data.getCharacter

          return (
            <div>
              {this.state.identityModalOpen && (
                <IdentityModal
                  requireCharacter
                  temporary
                  title={t('actions.upload_to', 'Upload To')}
                  onClose={this.handleIdentityClose.bind(this)}
                  onCharacterSelect={this.setCharacter.bind(this)}
                />
              )}

              <Modal
                id="upload-images"
                title={title}
                noContainer
                autoOpen
                onClose={this.handleClose.bind(this)}
              >
                {this.renderCharacterTarget(getCharacter, loading, error)}
                {this.renderCurrent(activeImage, getCharacter)}
                {this.renderPending(this.props.files)}
                {this.renderPlaceholder()}
              </Modal>
            </div>
          )
        }}
      </Query>
    )
  }
}

UploadModal.propTypes = {
  characterId: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
  onUpload: PropTypes.func,
  alwaysOpen: PropTypes.bool,
  activeImageId: PropTypes.string,
}

UploadModal.contextTypes = {
  getDropzone: PropTypes.func,
}

const mapStateToProps = ({ uploads }, props) => ({
  files: uploads.files,
  characterId: uploads.characterId,
  modalOpen: uploads.modalOpen,
  activeImageId: uploads.activeImageId,
  uploadCallback: uploads.uploadCallback,
  ...props,
})

const mapDispatchToProps = {
  clearUpload,
  modifyUpload,
  closeUploadModal,
}

const Wrapped = props => {
  const { alwaysOpen = false, modalOpen = false } = props

  if (!alwaysOpen && !modalOpen) {
    return null
  }

  return <UploadModal {...props} />
}

export default compose(
  withErrorBoundary,
  connect(mapStateToProps, mapDispatchToProps, null, { pure: false }),
  withTranslation('common')
)(Wrapped)
