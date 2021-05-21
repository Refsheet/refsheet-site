import React, { Component } from 'react'
import PropTypes from 'prop-types'
import imageProcessingComplete from './imageProcessingComplete.graphql'
import { Subscription } from 'react-apollo'
import { Icon } from 'react-materialize'
import { connect } from 'react-redux'
import { openLightbox, setNsfwMode } from '../../actions'
import NumberUtils from '../../v1/utils/NumberUtils'
import c from 'classnames'
import compose, { withMutations } from '../../utils/compose'
import deleteMedia from '../Lightbox/deleteMedia.graphql'
import updateImage from '../Lightbox/updateImage.graphql'
import CacheUtils from '../../utils/CacheUtils'
import Flash from '../../utils/Flash'
import { withTranslation } from 'react-i18next'

class Thumbnail extends Component {
  constructor(props) {
    super(props)

    this.handleClick = this.handleClick.bind(this)
    this.handleDeleteClick = this.handleDeleteClick.bind(this)
    this.handleFavoriteClick = this.handleFavoriteClick.bind(this)
    this.handleReprocessClick = this.handleReprocessClick.bind(this)
  }

  handleClick(e) {
    e.preventDefault()

    const {
      image: { id, nsfw },
      session: { nsfwOk },
      openLightbox,
      gallery,
      t,
      setNsfwMode,
    } = this.props

    if (nsfw && !nsfwOk) {
      if (
        confirm(
          t(
            'confirmations.nsfw_ok',
            'By continuing, you assert that you are 18 years or older, and that it is legal for you to view explicit content.'
          )
        )
      ) {
        setNsfwMode(true, true)
      }
    } else {
      openLightbox(id, gallery)
    }
  }

  handleFavoriteClick(e) {
    e.preventDefault()
    e.stopPropagation()

    const {
      image: { id },
    } = this.props

    console.log('Favorite ' + id)
  }

  handleReprocessClick(e) {
    e.preventDefault()

    const {
      image: { id },
      updateImage,
    } = this.props

    updateImage({
      wrapped: true,
      variables: {
        id,
        reprocess: true,
      },
    })
  }

  handleDeleteClick(e) {
    e.preventDefault()

    const {
      image: { id, title },
      deleteMedia,
    } = this.props

    if (confirm(`Really delete ${title}?`)) {
      deleteMedia({
        wrapped: true,
        variables: {
          mediaId: id,
        },
        update: CacheUtils.deleteMedia,
      })
        .then(data => {
          Flash.info('Image deleted.')
        })
        .catch(error => {
          console.error({ error })
          Flash.error('Something went wrong.')
        })
    }
  }

  renderNotification(icon, title, message, className, redrive = false) {
    return (
      <div className={'message center-align ' + className}>
        <i className={'material-icons ' + className}>{icon}</i>
        <div className={'caption margin-top--large ' + className}>{title}</div>
        <div className={'muted margin-top--medium ' + className}>{message}</div>
        {redrive && (
          <div className={'actions margin-top--small'}>
            <a
              href={'#'}
              onClick={this.handleReprocessClick}
              className={className}
            >
              Reprocess
            </a>{' '}
            |{' '}
            <a
              onClick={this.handleDeleteClick}
              href={'#'}
              className={className}
            >
              Delete
            </a>
          </div>
        )}
      </div>
    )
  }

  renderImage() {
    const {
      session: { nsfwOk },
      image: {
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
        url,
      },
      size,
    } = this.props

    let src = url[size || 'medium']

    if (!src) {
      console.log({ size, url })
      src = url[Object.keys[url][0]]
    }

    if (image_processing_error) {
      return this.renderNotification(
        'error',
        'Processing Error',
        `An error happened for image #${id}, and our system was unable to resize it.`,
        'red-text',
        true
      )
    } else if (image_processing) {
      const image_age = Date.now() / 1000 - created_at
      return this.renderNotification(
        'hourglass_empty',
        'Image processing...',
        'Thumbnails are being generated for this image, and should be available soon. ' +
          'You might need to reload this page. ' +
          image_age,
        undefined,
        created_at < Date.now() / 1000 - 3600
      )
    } else if (!aspect_ratio) {
      return this.renderNotification(
        'warning',
        'Invalid image :(',
        `Something's not quite right. This might be a bug. Report Image #${id}.`,
        'red-text',
        true
      )
    }

    const showNsfwWarning = nsfw && !nsfwOk

    return (
      <a
        onClick={this.handleClick}
        href={path}
        data-gallery-image-id={id}
        style={{ backgroundColor: background_color }}
      >
        {showNsfwWarning && (
          <div className="nsfw-cover" style={{ padding: '1rem' }}>
            <div
              style={{
                position: 'relative',
                top: '50%',
                transform: 'translateY(-50%)',
              }}
            >
              <Icon>remove_circle_outline</Icon>
              <div className="caption" style={{ paddingTop: '1rem' }}>
                Click to show NSFW content.
              </div>
            </div>
          </div>
        )}

        <div className="overlay">
          <div className="interactions">
            <div className="favs clickable" onClick={this.handleFavoriteClick}>
              <Icon>{is_favorite ? 'star' : 'star_outline'}</Icon>
              &nbsp;{NumberUtils.format(favorites_count)}
            </div>
            &nbsp;
            <div className="favs">
              <Icon>comment</Icon>
              &nbsp;{NumberUtils.format(comments_count)}
            </div>
          </div>

          <div className="image-title">
            <div className="truncate">{title}</div>
            {/*<div className='muted truncate'>By: { characterName }</div>*/}
          </div>
        </div>

        <img src={src} alt={title} title={title} />
      </a>
    )
  }

  render() {
    const {
      className,
      style,
      connectorFunc,
      innerRef,
      children,
      image = {},
      flat,
    } = this.props

    const preReturn = () => {
      return (
        <div
          ref={innerRef}
          style={{
            ...style,
            backgroundColor: image.background_color || 'rgb(0,0,0)',
          }}
          className={c('gallery-image image-thumbnail', className, {
            'z-depth-1': !flat,
          })}
        >
          {children}
          {this.renderImage()}
        </div>
      )
    }

    if (connectorFunc) {
      return connectorFunc(preReturn())
    } else {
      return preReturn()
    }
  }
}

Thumbnail.propTypes = {
  image: PropTypes.shape({
    url: PropTypes.shape({
      medium: PropTypes.string.isRequired,
    }).isRequired,
    size: PropTypes.shape({
      medium: PropTypes.shape({
        width: PropTypes.number.isRequired,
        height: PropTypes.number.isRequired,
      }).isRequired,
    }).isRequired,
    image_processing: PropTypes.bool,
  }),
  gallery: PropTypes.arrayOf(PropTypes.string),
}

const renderSubscribed = props => ({ data, loading, error }) => {
  let image = props.image

  if (!loading && data && data.imageProcessingComplete) {
    image = data.imageProcessingComplete
  }

  return <Thumbnail {...props} image={image} />
}

const Subscribed = props => {
  if (props.image.image_processing) {
    return (
      <Subscription
        subscription={imageProcessingComplete}
        variables={{ imageId: props.image.id }}
      >
        {renderSubscribed(props)}
      </Subscription>
    )
  } else {
    return <Thumbnail {...props} />
  }
}

const mapDispatchToProps = {
  openLightbox,
  setNsfwMode,
}

const mapStateToProps = ({ session }) => ({
  session,
})

export default compose(
  withMutations({ updateImage, deleteMedia }),
  connect(mapStateToProps, mapDispatchToProps),
  withTranslation('common')
)(Subscribed)
