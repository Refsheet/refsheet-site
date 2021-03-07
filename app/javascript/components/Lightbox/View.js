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
import { withTranslation } from 'react-i18next'
import compose from '../../utils/compose'
import Restrict from '../Shared/Restrict'
import ImageTagForm from './ImageTags/ImageTagForm'
import c from 'classnames'
import ImageTags from './ImageTags'
import { setNsfwMode } from '../../actions'
import { connect } from 'react-redux'

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editing: false,
      tagging: false,
      tags: [],
    }

    this.handleNsfwClick = this.handleNsfwClick.bind(this)
    this.handlePrevClick = this.handlePrevClick.bind(this)
    this.handleNextClick = this.handleNextClick.bind(this)
    this.handleEditStart = this.handleEditStart.bind(this)
    this.handleEditEnd = this.handleEditEnd.bind(this)
    this.handleTagStart = this.handleTagStart.bind(this)
    this.handleTagEnd = this.handleTagEnd.bind(this)
    this.handleMediaUpdate = this.handleMediaUpdate.bind(this)
    this.handleImageClick = this.handleImageClick.bind(this)
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
    this.setState({ tagging: true })
  }

  handleTagEnd() {
    this.setState({ tagging: false })
  }

  handleMediaUpdate() {
    this.setState({ editing: false })
  }

  handleNsfwClick(e) {
    e.preventDefault()
    this.props.setNsfwMode(true)
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
          name: 'Test!',
        },
      },
    ]

    this.setState({ tags })
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
          onSave={this.handleMediaUpdate}
          onCancel={this.handleEditEnd}
        />
      )
    } else if (this.state.tagging) {
      return (
        <ImageTagForm
          image={this.props.media}
          onSave={this.handleMediaUpdate}
          onCancel={this.handleTagEnd}
        />
      )
    } else {
      return (
        <div className={'image-details-container'}>
          <div className="image-details">
            {is_managed && (
              <ImageActions
                onEditClick={this.handleEditStart}
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
        nsfw,
      },
      nextMediaId,
      prevMediaId,
    } = this.props

    const { tags } = this.state

    return (
      <div className={'lightbox-content'}>
        <div className={c('image-content', { tagging: this.state.tagging })}>
          {prevMediaId && (
            <a
              className={'image-prev image-nav'}
              href={`/media/${prevMediaId}`}
              title={t('actions.previous_media', 'Previous Image')}
              onClick={this.handlePrevClick}
            >
              <Icon>keyboard_arrow_left</Icon>
            </a>
          )}

          {nextMediaId && (
            <a
              className={'image-next image-nav'}
              href={`/media/${nextMediaId}`}
              title={t('actions.next_media', 'Next Image')}
              onClick={this.handleNextClick}
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
                  onClick={this.handleTagStart}
                  title={t('actions.tag_characters', 'Tag Characters')}
                >
                  <Icon className={'left'}>tag_faces</Icon>
                  {t('actions.tag_characters', 'Tag Characters')}
                </a>
              </Restrict>
            </div>
          </div>

          <Restrict nsfw={nsfw}>
            <ImageLoader src={imageSrc}>
              <img alt={title} title={title} onClick={this.handleImageClick} />
              <Error />
              <Loading />
            </ImageLoader>
          </Restrict>
          <Restrict invert nsfw={nsfw}>
            <a className="nsfw-cover" onClick={this.handleNsfwClick}>
              <Icon>remove_circle_outline</Icon>
              <div className="caption">Click to show NSFW content.</div>
            </a>
          </Restrict>

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

const mapDispatchToProps = {
  setNsfwMode,
}

export default compose(
  connect(undefined, mapDispatchToProps),
  withTranslation('common')
)(View)
