import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import GalleryImage from 'v1/shared/images/GalleryImage'
import $ from 'jquery'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let GalleryFeature
export default GalleryFeature = createReactClass({
  propTypes: {
    editable: PropTypes.bool,
    first: PropTypes.object,
    second: PropTypes.object,
    third: PropTypes.object,
    onImageSwap: PropTypes.func,
    onImageClick: PropTypes.func,
    gallery: PropTypes.array,
  },

  componentDidMount() {
    $(window).resize(this._initialize)
    return this._initialize()
  },

  componentDidRecieveProps(newProps) {
    if (
      (this.props.first != null ? this.props.first.id : undefined) !==
        (newProps.first != null ? newProps.first.id : undefined) ||
      (this.props.second != null ? this.props.second.id : undefined) !==
        (newProps.second != null ? newProps.second.id : undefined) ||
      (this.props.third != null ? this.props.third.id : undefined) !==
        (newProps.third != null ? newProps.third.id : undefined)
    ) {
      return this._initialize()
    }
  },

  componentDidUpdate() {
    return this._initialize()
  },

  componentWillUnmount() {
    return $(window).off('resize', this._initialize)
  },

  _initialize() {
    console.debug('[GalleryFeature] Initializing featured gallery...')

    return $(this.refs.galleryFeature).imagesLoaded(() => {
      const select = selector => {
        return $(this.refs.galleryFeature).find(selector)
      }
      const width = selector => {
        return select(selector).width()
      }
      const height = selector => {
        return select(selector).height()
      }

      const ratio = selector => {
        let end
        if (select(selector).data('aspect-ratio')) {
          end = select(selector).data('aspect-ratio')
        } else {
          end = height(selector + ' img') / width(selector + ' img') || 1
          select(selector).data('aspect-ratio', end)
        }
        return end
      }

      const g = 15
      const x0 = $(this.refs.galleryFeature).width() - 5
      const r1 = ratio('.feature-main')
      const r2 = ratio('.side-image.top')
      const r3 = ratio('.side-image.bottom')

      // Lots of magic. Ask Wolfram Alpha.
      const t = g - g * r2 - g * r3 + r2 * x0 + r3 * x0
      const b = r1 + r2 + r3
      const x1 = t / b
      const x2 = x0 - x1 - g
      const y1 = x1 * r1
      const y2 = x2 * r2
      const y3 = x2 * r3

      $(this.refs.featureMain)
        .css({
          width: x1,
          height: y1,
        })
        .children('.feature-main')
        .addClass('gf-entry')

      $(this.refs.featureSide).css({
        width: x2,
      })

      setTimeout(() => {
        return $(this.refs.featureSide)
          .children('.top')
          .css({
            height: y2,
          })
          .addClass('gf-entry')
      }, 250)

      return setTimeout(() => {
        return $(this.refs.featureSide)
          .children('.bottom')
          .css({
            height: y3,
          })
          .addClass('gf-entry')
      }, 500)
    })
  },

  render() {
    const firstId =
      (this.props.first != null ? this.props.first.id : undefined) ||
      'placeholder-first'
    const secondId =
      (this.props.second != null ? this.props.second.id : undefined) ||
      'placeholder-second'
    const thirdId =
      (this.props.third != null ? this.props.third.id : undefined) ||
      'placeholder-third'

    return (
      <div ref="galleryFeature" className="gallery-feature">
        <div ref="featureMain" className="feature-left">
          <GalleryImage
            key={firstId}
            className="feature-main"
            image={this.props.first}
            size="large"
            onClick={this.props.onImageClick}
            onSwap={this.props.onImageSwap}
            gallery={this.props.gallery}
            editable={this.props.editable}
          />
        </div>

        <div ref="featureSide" className="feature-side">
          <GalleryImage
            key={secondId}
            className="side-image top"
            image={this.props.second}
            size="medium"
            onClick={this.props.onImageClick}
            onSwap={this.props.onImageSwap}
            gallery={this.props.gallery}
            editable={this.props.editable}
          />

          <GalleryImage
            key={thirdId}
            className="side-image bottom"
            image={this.props.third}
            size="medium"
            onClick={this.props.onImageClick}
            onSwap={this.props.onImageSwap}
            gallery={this.props.gallery}
            editable={this.props.editable}
          />
        </div>
      </div>
    )
  },
})
