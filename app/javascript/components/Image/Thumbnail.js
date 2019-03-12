import React, { Component } from 'react'
import PropTypes from 'prop-types'
import imageProcessingComplete from './imageProcessingComplete.graphql'
import {Subscription} from "react-apollo";
import {Icon} from 'react-materialize'
import {connect} from "react-redux";
import {openLightbox} from "../../actions";

class Thumbnail extends Component {
  constructor(props) {
    super(props)
  }

  handleClick(e) {
    e.preventDefault()

    const {
      image: {
        id
      },
      openLightbox,
      gallery
    } = this.props

    openLightbox(id, gallery)
  }

  handleFavoriteClick(e) {
    e.preventDefault()
    e.stopPropagation()

    const {
      image: {
        id
      }
    } = this.props

    console.log("Favorite " + id)
  }

  renderNotification(icon, title, message, className) {
    return (
      <div className={'message center-align ' + className}>
        <i className={'material-icons'}>{icon}</i>
        <div className='caption margin-top--large'>{title}</div>
        <div className='muted margin-top--medium'>{message}</div>
      </div>
    )
  }

  renderImage() {
    const {
      session: {
        nsfwOk
      },
      image: {
        image_processing,
        aspect_ratio,
        id,
        path,
        background_color,
        nsfw,
        favorites_count,
        comments_count,
        is_favorite,
        title,
        url: {
          medium: src
        }
      }
    } = this.props

    if (image_processing) {
      return this.renderNotification(
        'hourglass_empty',
        'Image processing...',
        'Thumbnails are being generated for this image, and should be available soon. ' +
        'You might need to reload this page.')
    } else if (!aspect_ratio) {
      return this.renderNotification(
        'warning',
        'Invalid image :(',
        `Something's not quite right. This might be a bug. Report Image #${id}.`,
        'red-text'
      )
    }

    const showNsfwWarning = nsfw && !nsfwOk

    return (
      <a onClick={ this.handleClick.bind(this) }
         href={ path }
         data-gallery-image-id={ id }
         style={{ backgroundColor: background_color }}
      >
        { showNsfwWarning && <div className='nsfw-cover'>
          <Icon>remove_circle_outline</Icon>
          <div className='caption'>Click to show NSFW content.</div>
        </div> }

        <div className='overlay'>
          <div className='interactions'>
            <div className='favs clickable' onClick={ this.handleFavoriteClick.bind(this) }>
              <Icon>{ is_favorite ? 'star' : 'star_outline' }</Icon>
              &nbsp;{ NumberUtils.format(favorites_count) }
            </div>
            &nbsp;
            <div className='favs'>
              <Icon>comment</Icon>
              &nbsp;{ NumberUtils.format(comments_count) }
            </div>
          </div>

          <div className='image-title'>
            <div className='truncate'>{ title }</div>
            {/*<div className='muted truncate'>By: { characterName }</div>*/}
          </div>
        </div>

        <img src={ src } alt={ title } title={ title } />
      </a>
    )
  }

  render() {
    const {
      style
    } = this.props

    return (
      <div style={style} className='gallery-image image-thumbnail black z-depth-1'>
        { this.renderImage() }
      </div>
    )
  }
}

Thumbnail.propTypes = {
  image: PropTypes.shape({
    url: PropTypes.shape({
      medium: PropTypes.string.isRequired
    }).isRequired,
    size: PropTypes.shape({
      medium: PropTypes.shape({
        width: PropTypes.number.isRequired,
        height: PropTypes.number.isRequired
      }).isRequired
    }).isRequired,
    image_processing: PropTypes.bool
  }),
  gallery: PropTypes.arrayOf(PropTypes.string)
}

const renderSubscribed = (props) => ({data, loading, error}) => {
  let image = props.image

  if (!loading && data && data.imageProcessingComplete) {
    image = data.imageProcessingComplete
  }

  return <Thumbnail {...props} image={image} />
}

const Subscribed = (props) => {
  if(props.image.image_processing) {
    return <Subscription subscription={imageProcessingComplete} variables={{ imageId: props.image.id }}>
      {renderSubscribed(props)}
    </Subscription>
  } else {
    return <Thumbnail {...props} />
  }
}

const mapDispatchToProps = {
  openLightbox
}

const mapStateToProps = ({session}) => ({
  session
})

export default connect(mapStateToProps, mapDispatchToProps)(Subscribed)
