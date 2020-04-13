import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Modal from 'v1/shared/Modal'
import ImageGallery from 'v1/shared/images/ImageGallery'
import $ from 'jquery'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ImageGalleryModal
export default ImageGalleryModal = createReactClass({
  handleUploadClick() {
    return this.props.onUploadClick()
  },

  render() {
    let images
    if (this.props.hideNsfw && this.props.images) {
      images = this.props.images.filter(i => !i.nsfw)
    } else {
      images = this.props.images
    }

    return (
      <Modal
        id="image-gallery-modal"
        title={this.props.title || 'Character Uploads'}
        actions={[{ name: 'Upload...', action: this.handleUploadClick }]}
      >
        <ImageGallery
          v2Data
          images={images}
          noOverlay
          onImageClick={this.props.onClick}
          noFeature
        />
      </Modal>
    )
  },
})
