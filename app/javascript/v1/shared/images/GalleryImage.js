import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import Icon from 'v1/shared/material/Icon'
import Model from '../../utils/Model'
import NumberUtils from '../../utils/NumberUtils'

import $ from 'jquery'
import compose from '../../../utils/compose'
import Thumbnail from '../../../components/Image/Thumbnail'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const gallery_image = createReactClass({
  propTypes: {
    image: PropTypes.object,
    editable: PropTypes.bool,
    wrapperClassName: PropTypes.string,
    className: PropTypes.string,
    size: PropTypes.string,
    onSwap: PropTypes.func,
    onClick: PropTypes.func,
    gallery: PropTypes.array,
  },

  getInitialState() {
    return { image: this.props.image }
  },

  load(image) {
    return this.setState({ image }, this._initialize)
  },

  _handleFavoriteClick(e) {
    const action = (
      this.state.image != null ? this.state.image.is_favorite : undefined
    )
      ? 'delete'
      : 'post'
    Model.request(
      action,
      '/media/' + this.state.image.id + '/favorites',
      {},
      data => {
        return this._handleFavorite(!!data.media_id)
      }
    )
    return e.preventDefault()
  },

  _handleFavorite(fav) {
    const o = this.state.image
    o.is_favorite = fav
    this.setState({ image: o })
    return $(document).trigger('app:image:update', o)
  },

  _handleClick(e) {
    const $target = $(e.target)
    if ($target.prop('tagName') === 'IMG') {
      if (this.props.onClick && this.props.onClick(this.state.image)) {
        true
      } else {
        this.props.dispatch({
          type: 'OPEN_LIGHTBOX',
          mediaId: this.state.image != null ? this.state.image.id : undefined,
          gallery: this.props.gallery,
        })
      }
    } else if (this.state.image.nsfw && !this.props.session.nsfwOk) {
      this.props.dispatch({ type: 'SET_NSFW_MODE', nsfwOk: true })
    }

    return e.preventDefault()
  },

  _initialize() {
    if (!this.state.image) {
      return
    }

    const $image = $(this.refs.image)

    if (this.props.editable) {
      const _this = this

      $image.draggable({
        revert: true,
        opacity: 0.6,
        appendTo: 'body',
        cursorAt: {
          top: 5,
          left: 5,
        },
        helper: () => {
          return $(`<div class='card-panel'>${this.state.image.title}</div>`)
        },
      })

      return $image.droppable({
        tolerance: 'pointer',
        drop: (event, ui) => {
          const $source = ui.draggable
          const sourceId = $source.data('gallery-image-id')
          if (_this.props.onSwap) {
            return _this.props.onSwap(sourceId, this.state.image.id)
          }
        },
      })
    }
  },

  _updateEvent(e, image) {
    if (!this.state.image || !image || this.state.image.id !== image.id) {
      return
    }
    return this.load(image)
  },

  componentDidMount() {
    this._initialize()

    return $(document).on('app:image:update', this._updateEvent)
  },

  componentWillUnmount() {
    return $(document).off('app:image:update', this._updateEvent)
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (newProps.image != null) {
      return this.load(newProps.image)
    }
  },

  render() {
    const { noOverlay } = this.props

    let contents
    const classNames = ['gallery-image']
    if (this.props.className) {
      classNames.push(this.props.className)
    }
    if (this.props.editable) {
      classNames.push('draggable')
    }

    if (this.state.image) {
      let imageSrc
      if (typeof this.state.image.url === 'object') {
        imageSrc =
          this.state.image.url[this.props.size] || this.state.image.url['large']
      } else {
        imageSrc =
          this.state.image[this.props.size] || this.state.image['large']
      }

      const showNsfwWarning =
        this.state.image.nsfw &&
        !(this.props.session != null ? this.props.session.nsfw_ok : undefined)

      contents = (
        <a
          ref="image"
          className={classNames.join(' ')}
          onClick={this._handleClick}
          href={this.state.image.path}
          data-gallery-image-id={this.state.image.id}
          style={{ backgroundColor: this.state.image.background_color }}
        >
          {showNsfwWarning && (
            <div className="nsfw-cover">
              <Icon>remove_circle_outline</Icon>
              <div className="caption">Click to show NSFW content.</div>
            </div>
          )}

          {!noOverlay && (
            <div className="overlay">
              <div className="interactions">
                <div
                  className="favs clickable"
                  onClick={this._handleFavoriteClick}
                >
                  <Icon>
                    {this.state.image.is_favorite ? 'star' : 'star_outline'}
                  </Icon>
                  &nbsp;{NumberUtils.format(this.state.image.favorites_count)}
                </div>
                &nbsp;
                <div className="favs">
                  <Icon>comment</Icon>
                  &nbsp;{NumberUtils.format(this.state.image.comments_count)}
                </div>
              </div>

              <div className="image-title">
                <div className="truncate">{this.state.image.title}</div>
                {this.state.image.character && (
                  <div className="muted truncate">
                    By: {this.state.image.character.name}
                  </div>
                )}
              </div>
            </div>
          )}

          <img
            src={imageSrc}
            alt={this.state.image.title}
            title={this.state.image.title}
          />
        </a>
      )
    } else {
      classNames.push('image-placeholder')

      contents = <div className={classNames.join(' ')} />
    }

    if (this.props.wrapperClassName) {
      return <div className={this.props.wrapperClassName}>{contents}</div>
    } else {
      return contents
    }
  },
})

const mapStateToProps = state => ({
  currentUser: state.session.currentUser,
  session: state.session,
})

const V1GalleryImage = compose(connect(mapStateToProps))(gallery_image)

const V2ThumbnailWrapper = props => {
  /*
  created_at,
        image_processing,
        image_processing_error,
        aspect_ratio,
        id,
        path,
        background_color,
        nsfw,
        favorites_count,
        comments_count,
        is_favorite,
        title,
        url: { medium: src }
   */

  const aspect_ratio = props.aspectRatio || 1

  const v2props = {
    ...props,
    image: {
      ...props.image,
      aspect_ratio,
    },
    style: {
      paddingBottom: `${aspect_ratio * 100}%`,
    },
  }

  return <Thumbnail flat {...v2props} />
}

export default V2ThumbnailWrapper

export { V1GalleryImage }
