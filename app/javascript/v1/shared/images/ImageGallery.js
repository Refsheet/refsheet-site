import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Spinner from 'v1/shared/material/Spinner'
import { V1GalleryImage } from 'v1/shared/images/GalleryImage'
import GalleryFeature from 'v1/shared/images/GalleryFeature'

import ArrayUtils from 'v1/utils/ArrayUtils'
import * as Materialize from 'materialize-css'
import $ from 'jquery'
import StateUtils from 'v1/utils/StateUtils'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ImageGallery
export default ImageGallery = createReactClass({
  propTypes: {
    editable: PropTypes.bool,
    noFeature: PropTypes.bool,
    noOverlay: PropTypes.bool,
    noSquare: PropTypes.bool,
    imagesPath: PropTypes.string,
    images: PropTypes.array,
    onImageClick: PropTypes.func,
    onImagesLoaded: PropTypes.func,
  },

  getInitialState() {
    return {
      append: false,
      images: this.props.images || null,
    }
  },

  load(data, sendCallback) {
    if (sendCallback == null) {
      sendCallback = true
    }
    const s = { images: data }

    if (this.state.images > 0 && data.length > 0) {
      const new_ids = ArrayUtils.pluck(data, 'id')
      const old_ids = ArrayUtils.pluck(this.state.images, 'id')

      if (ArrayUtils.diff(new_ids, old_ids).length === data.length) {
        s.append = true
      }
    }

    this.setState(s, this._initialize)
    if (this.props.onImagesLoad && sendCallback) {
      return this.props.onImagesLoad(data)
    }
  },

  componentDidMount() {
    if (this.props.imagesPath != null && !this.props.images) {
      console.debug('[ImageGallery] Fetching:', this.props.imagesPath)
      $.get(this.props.imagesPath, this.load)
    } else {
      this._initialize()
    }

    return $(window).resize(this._resizeJg)
  },

  componentWillUnmount() {
    // if (this.refs.gallery) {
    //   $(this.refs.gallery).justifiedGallery('destroy')
    // }
    //
    // return $(window).off('resize', this._resizeJg)
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.images) {
      return this.load(newProps.images, false)
    }
  },

  _resizeJg() {
    // if (this.props.noFeature && !this.props.noSquare) {
    //   return
    // }
    // if (this.refs.gallery) {
    //   return $(this.refs.gallery).justifiedGallery(this._getJgRowHeight())
    // }
  },

  _handleImageSwap(source, target) {
    // Model.patch "/images/#{source}", (data) =>
    //   Materialize.toast 'Image moved!', 3000, 'green'
    //   @load data

    $(document).trigger('app:loading')
    return $.ajax({
      url: '/images/' + source,
      type: 'PATCH',
      data: { image: { swap_target_image_id: target } },
      success: data => {
        Materialize.toast({
          html: 'Image moved!',
          displayLength: 3000,
          classes: 'green',
        })
        return this.load(data)
      },
      error: error => {
        return console.log(error)
      },
      complete() {
        return $(document).trigger('app:loading:done')
      },
    })
  },

  _handleImageClick(image) {
    if (this.props.onImageClick != null) {
      this.props.onImageClick(image.id)
      return true
    }
    return false
  },

  _handleImageChange(image) {
    console.debug('[ImageGallery] Lightbox changed image:', image)
    return StateUtils.updateItem(this, 'images', image, 'id')
  },

  _handleImageDelete(id) {
    console.debug('[ImageGallery] Lightbox deleted image:', id)
    return StateUtils.removeItem(this, 'images', id, 'id')
  },

  _getJgRowHeight() {
    const coef = $(window).width() < 900 ? 1 : 0.7
    return {
      rowHeight: $(window).width() * (coef * 0.25),
      maxRowHeight: $(window).width() * (coef * 0.4),
    }
  },

  _getThumbnailPath(currentPath, width, height, image) {
    let currentSize, newSize
    if (!currentPath) {
      currentPath = ''
    }

    const results = currentPath.match(/\d{3}\/\d{3}\/\d{3}\/(\w+)\//)

    if (results) {
      currentSize = results[1]
    } else {
      currentSize = 'medium'
    }

    const max = Math.max(width, height)

    if (max <= 427) {
      newSize = 'small'
    } else if (max <= 854) {
      newSize = 'medium'
    } else {
      newSize = 'large'
    }

    return currentPath.replace(
      /(\d{3}\/\d{3}\/\d{3}\/)\w+\//,
      '$1' + newSize + '/'
    )
  },

  _initialize() {
    if (this.props.noFeature && !this.props.noSquare) {
      return
    }

    if (this.state.images.length === 0 || !this.refs.gallery) {
      console.debug('[ImageGallery] Empty, no init.')
      return
    }

    if (this.state.append) {
      console.debug('[ImageGallery] Init with norewind.')
      // try {
      //   $(this.refs.gallery).justifiedGallery('norewind')
      // } catch (e) {
      //   console.warn('Attempted to set norewind on an empty gallery.', e)
      // }

      return
    }

    console.debug('[ImageGallery] Initializing Justified Gallery...')

    let opts = {
      selector: '.gallery-image',
      margins: 15,
      captions: false,
      thumbnailPath: this._getThumbnailPath,
    }

    opts = $.extend({}, opts, this._getJgRowHeight())
    // $(this.refs.gallery).justifiedGallery(opts)
    return this.setState({ append: true })
  },

  render() {
    let editable, first, imageSize, overflow, second, third
    let galleryClassName = 'justified-gallery'
    let imageClassName = ''
    let wrapperClassName = ''
    const _this = this

    const { noOverlay } = this.props

    const imageIds =
      this.state.images != null ? this.state.images.map(i => i.id) : undefined

    if (this.state.images == null) {
      return <Spinner />
    }

    if (this.props.editable) {
      editable = true
    }

    if (!this.props.noFeature) {
      ;[first, second, third, ...overflow] = Array.from(this.state.images)
      imageSize = 'medium'
    } else if (this.props.noSquare) {
      overflow = this.state.images
      imageSize = 'medium'
    } else {
      galleryClassName = 'row'
      wrapperClassName = 'col s6 m3'
      imageClassName = 'no-jg'
      overflow = this.state.images
      imageSize = 'small_square'
    }

    const imagesOverflow = overflow.map(image => {
      return (
        <V1GalleryImage
          key={image.id}
          image={image}
          size={imageSize}
          onClick={_this._handleImageClick}
          onSwap={_this._handleImageSwap}
          wrapperClassName={wrapperClassName}
          className={imageClassName}
          noOverlay={noOverlay}
          gallery={imageIds}
          editable={editable}
        />
      )
    })

    if (this.state.images != null ? this.state.images.length : undefined) {
      return (
        <div ref="imageGallery" className="image-gallery">
          {!this.props.noFeature && (
            <GalleryFeature
              first={first}
              second={second}
              third={third}
              onImageClick={this._handleImageClick}
              onImageSwap={this._handleImageSwap}
              gallery={imageIds}
              noOverlay={noOverlay}
              editable={editable}
            />
          )}

          {imagesOverflow.length > 0 && (
            <div ref="gallery" className={galleryClassName}>
              {imagesOverflow}
            </div>
          )}
        </div>
      )
    } else if (this.props.edit) {
      return (
        <div className="image-gallery">
          <div className="caption center">
            Drag and drop images from your computer to your character pages to
            start a gallery.
          </div>
        </div>
      )
    } else {
      return (
        <div className="image-gallery">
          <div className="caption center">
            This character has not submitted any images
          </div>
        </div>
      )
    }
  },
})
