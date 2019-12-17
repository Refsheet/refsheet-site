import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'
import ImageLoader from 'react-load-image'
import { Loading, Error } from './Status'
import CharacterBox from "./CharacterBox";
import ImageMeta from "./ImageMeta";
import Comments from './Comments';
import {Link} from "react-router-dom";
import Favorites from "./Favorites";

class View extends Component {
  constructor(props) {
    super(props)
  }

  handlePrevClick(e) {
    e.preventDefault()
    this.props.onMediaOpen(this.props.prevMediaId)
  }

  handleNextClick(e) {
    e.preventDefault()
    this.props.onMediaOpen(this.props.nextMediaId)
  }

  render() {
    const {
      id,
      title,
      url: {
        large: imageSrc
      },
      created_at,
      character,
      favorites,
      favorites_count,
      comments_count,
      is_managed,
      is_favorite,
      nextMediaId,
      prevMediaId
    } = this.props

    return (
      <div className={'lightbox-content'}>
        <div className={'image-content'}>
          { prevMediaId && <a className={'image-prev image-nav'} href={`/media/${prevMediaId}`} onClick={this.handlePrevClick.bind(this)}>
            <Icon>keyboard_arrow_left</Icon>
          </a> }

          { nextMediaId && <a className={'image-next image-nav'} href={`/media/${nextMediaId}`} onClick={this.handleNextClick.bind(this)}>
            <Icon>keyboard_arrow_right</Icon>
          </a> }

          <ImageLoader src={imageSrc}>
            <img alt={title} title={title} />
            <Error />
            <Loading />
          </ImageLoader>
        </div>

        <div className={'image-details-container'}>
          <div className='image-details'>
            <CharacterBox {...character} createdAt={created_at} />
            <ImageMeta {...this.props} />
          </div>

          <Favorites count={favorites_count} favorites={favorites} isFavorite={is_favorite} mediaId={id} />
          <Comments count={comments_count} isManaged={is_managed} mediaId={id} />
        </div>
      </div>
    )
  }
}

View.propTypes = {
  onMediaOpen: PropTypes.func.isRequired
}

export default View