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
      images = $.grep(this.props.images, i => !i.nsfw)
    } else {
      ;({ images } = this.props)
    }

    return (
      <Modal
        id="image-gallery-modal"
        title={this.props.title || 'Character Uploads'}
        actions={[{ name: 'Upload...', action: this.handleUploadClick }]}
      >
        <div className="card card-panel green darken-3 white-text">
          <strong>Note:</strong> We're in the process of completely rewriting
          character profiles, so please pardon our dust while we upgrade things.
          After uploading images to V1 character pages,{' '}
          <strong>you will have to reload the page</strong>.{' '}
          <a
            href="https://refsheet.net/v2/forums/support/uploading-to-v1-profiles"
            rel="noopener noreferrer"
            target="_blank"
          >
            Here is a forum post
          </a>{' '}
          explaining things a bit more.
        </div>

        <ImageGallery
          images={images}
          onImageClick={this.props.onClick}
          noFeature
        />
      </Modal>
    )
  },
})
