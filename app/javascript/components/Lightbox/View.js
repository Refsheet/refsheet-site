import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'
import ImageLoader from 'react-load-image'
import { Loading, Error } from './Status'
import CharacterBox from './CharacterBox'
import ImageMeta from './ImageMeta'
import Comments from './Comments'
import Favorites from './Favorites'
import ImageActions from './ImageActions'
import ImageEditForm from './ImageEditForm'
import { withNamespaces } from 'react-i18next'
import compose from '../../utils/compose'
import Restrict from '../Shared/Restrict'
import ImageTagForm from "./ImageTags/ImageTagForm";
import c from 'classnames'
import {Link} from "react-router-dom";
import ImageTags from "./ImageTags";

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
      tagging: false,
      tags: []
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

  handleEditEnd() {
    this.setState({ editing: false })
  }

  handleTagStart(e) {
    e.preventDefault()
    this.setState({tagging: true})
  }

  handleTagEnd() {
    this.setState({tagging: false})
  }

  handleMediaUpdate() {
    this.setState({ editing: false })
  }

  handleImageClick(e) {
    e.preventDefault()

    const { top, left } = e.target.getBoundingClientRect()
    const x = e.pageX - left - window.pageXOffset
    const y = e.pageY - top - window.pageYOffset

    const cw = e.target.clientWidth
    const ch = e.target.clientHeight

    const xp = x / cw
    const yp = y / ch

    let tags = [
      ...this.state.tags,
      {
        position_x: xp * 100,
        position_y: yp * 100,
        character: {
          name: "Test!"
        }
      }
    ]

    this.setState({tags})
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
      download_link,
    } = this.props.media

    if (this.state.editing) {
      return (
        <ImageEditForm
          image={this.props.media}
          onSave={this.handleMediaUpdate.bind(this)}
          onCancel={this.handleEditEnd.bind(this)}
        />
      )
    } else if (this.state.tagging) {
      return (
        <ImageTagForm
          image={this.props.media}
          onSave={this.handleMediaUpdate.bind(this)}
          onCancel={this.handleTagEnd.bind(this)}
        />
      )
    } else {
      return (
        <div className={'image-details-container'}>
          <div className="image-details">
            {is_managed && (
              <ImageActions
                onEditClick={this.handleEditStart.bind(this)}
                downloadLink={download_link}
                mediaId={this.props.media.id}
              />
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
      t,
      media: {
        title,
        url: { large: imageSrc },
      },
      nextMediaId,
      prevMediaId,
    } = this.props

    const {
      tags
    } = this.state

    return (
      <div className={'lightbox-content'}>
        <div className={c('image-content', { tagging: this.state.tagging})}>
          {prevMediaId && (
            <a
              className={'image-prev image-nav'}
              href={`/media/${prevMediaId}`}
              title={t('actions.previous_media', 'Previous Image')}
              onClick={this.handlePrevClick.bind(this)}
            >
              <Icon>keyboard_arrow_left</Icon>
            </a>
          )}

          {nextMediaId && (
            <a
              className={'image-next image-nav'}
              href={`/media/${nextMediaId}`}
              title={t('actions.next_media', 'Next Image')}
              onClick={this.handleNextClick.bind(this)}
            >
              <Icon>keyboard_arrow_right</Icon>
            </a>
          )}

          <div className={'lightbox-overlay top'}>
            <h1>{title}</h1>
          </div>

          <div className={'lightbox-overlay bottom'}>
            <div className={'left'}>
              <Restrict development>
                <a
                  className={'block red-text'}
                  href={'#'}
                  title={t('actions.report_image', 'Report')}
                >
                  <Icon className={'left'}>report</Icon>
                  {t('actions.report_image', 'Report')}
                </a>
              </Restrict>
            </div>
            <div className={'right'}>
              <Restrict patron>
                <a
                  className={'block'}
                  href={'#'}
                  onClick={this.handleTagStart.bind(this)}
                  title={t('actions.tag_characters', 'Tag Characters')}
                >
                  <Icon className={'left'}>tag_faces</Icon>
                  {t('actions.tag_characters', 'Tag Characters')}
                </a>
              </Restrict>
            </div>
          </div>

          <ImageLoader src={imageSrc}>
            <img alt={title} title={title} onClick={this.handleImageClick.bind(this)} />
            <Error />
            <Loading />
          </ImageLoader>

          <ImageTags tags={this.state.tags} tagging={this.state.tagging} />
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

export default compose(withNamespaces('common'))(View)
