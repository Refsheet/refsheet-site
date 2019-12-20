import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'
import ImageLoader from 'react-load-image'
import { Loading, Error } from './Status'
import CharacterBox from './CharacterBox'
import ImageMeta from './ImageMeta'
import Comments from './Comments'
import { Link } from 'react-router-dom'
import Favorites from './Favorites'
import ImageActions from './ImageActions'
import ImageEditForm from './ImageEditForm'

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
    }
  }

  handlePrevClick(e) {
    e.preventDefault()
    this.props.onMediaOpen(this.props.prevMediaId)
  }

  handleNextClick(e) {
    e.preventDefault()
    this.props.onMediaOpen(this.props.nextMediaId)
  }

  handleEditStart() {
    this.setState({ editing: true })
  }

  renderDetails() {
    const {
      id,
      created_at,
      character,
      favorites,
      favorites_count,
      comments_count,
      is_managed,
      is_favorite,
    } = this.props.media

    if (this.state.editing) {
      return <ImageEditForm image={this.props.media} />
    } else {
      return (
        <div className={'image-details-container'}>
          <div className="image-details">
            {is_managed && (
              <ImageActions onEditClick={this.handleEditStart.bind(this)} />
            )}
            <CharacterBox {...character} createdAt={created_at} />
            <ImageMeta {...this.props.media} />
          </div>

          <Favorites
            count={favorites_count}
            favorites={favorites}
            isFavorite={is_favorite}
            mediaId={id}
          />
          <Comments
            count={comments_count}
            isManaged={is_managed}
            mediaId={id}
          />
        </div>
      )
    }
  }

  render() {
    const {
      media: {
        title,
        url: { large: imageSrc },
      },
      nextMediaId,
      prevMediaId,
    } = this.props

    return (
      <div className={'lightbox-content'}>
        <div className={'image-content'}>
          {prevMediaId && (
            <a
              className={'image-prev image-nav'}
              href={`/media/${prevMediaId}`}
              onClick={this.handlePrevClick.bind(this)}
            >
              <Icon>keyboard_arrow_left</Icon>
            </a>
          )}

          {nextMediaId && (
            <a
              className={'image-next image-nav'}
              href={`/media/${nextMediaId}`}
              onClick={this.handleNextClick.bind(this)}
            >
              <Icon>keyboard_arrow_right</Icon>
            </a>
          )}

          <ImageLoader src={imageSrc}>
            <img alt={title} title={title} />
            <Error />
            <Loading />
          </ImageLoader>
        </div>

        {this.renderDetails()}
      </div>
    )
  }
}

View.propTypes = {
  onMediaOpen: PropTypes.func.isRequired,
  media: PropTypes.object.isRequired,
}

export default View
