import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import LightboxCharacterBox from './LightboxCharacterBox'
import RichText from '../../../components/Shared/RichText'
import Tabs from '../tabs/Tabs'
import Tab from '../tabs/Tab'
import Form from '../forms/Form'
import Input from '../forms/Input'
import Row from '../material/Row'
import Column from 'react-virtualized/dist/commonjs/Table/Column'
import Submit from '../forms/Submit'
import Modal from '../Modal'
import ImageGravityModal from '../modals/ImageGravityModal'

import FavoriteButton from 'v1/views/favorites/_button'
import Comments from 'v1/views/comments'
import Favorites from 'v1/views/favorites'
import Spinner from 'v1/shared/material/Spinner'

import $ from 'jquery'
import ObjectPath from '../../utils/ObjectPath'
import StateUtils from '../../utils/StateUtils'
import HashUtils from '../../utils/HashUtils'
import compose, { withCurrentUser } from '../../../utils/compose'
import { withRouter } from 'react-router'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Lightbox = createReactClass({
  contextTypes: {
    reportImage: PropTypes.func.isRequired,
  },

  getInitialState() {
    return {
      image: null,
      error: null,
      directLoad: false,
    }
  },

  handleCaptionChange(data, onSuccess, onError) {
    return $.ajax({
      url: this.state.image.path,
      type: 'PATCH',
      data: { image: { caption: data } },
      success: data => {
        this.setState({ image: data })
        return onSuccess()
      },
      error: error => {
        return onError(error)
      },
    })
  },

  setFeaturedImage(e) {
    $.ajax({
      url: this.state.image.character.path,
      type: 'PATCH',
      data: { character: { featured_image_guid: this.state.image.id } },
      success: data => {
        Materialize.toast({
          html: 'Cover image changed!',
          displayLength: 3000,
          classes: 'green',
        })
        return $(document).trigger('app:character:update', data)
      },

      error: error => {
        console.log(error)
        return Materialize.toast({
          html: 'Error?',
          displayLength: 3000,
          classes: 'red',
        })
      },
    })

    return e.preventDefault()
  },

  setProfileImage(e) {
    $.ajax({
      url: this.state.image.character.path,
      type: 'PATCH',
      data: { character: { profile_image_guid: this.state.image.id } },
      success: data => {
        Materialize.toast({
          html: 'Profile image changed!',
          displayLength: 3000,
          classes: 'green',
        })
        return $(document).trigger('app:character:update', data)
      },

      error: error => {
        console.error(error)
        return Materialize.toast({
          html: 'Error?',
          displayLength: 3000,
          classes: 'red',
        })
      },
    })

    return e.preventDefault()
  },

  handleDelete(e) {
    const $el = $(e.target)
    if ($el.hasClass('disabled')) {
      return
    }
    $el.addClass('disabled')
    $el.text('Deleting...')
    $.ajax({
      url: this.state.image.path,
      type: 'DELETE',
      success: () => {
        const { id } = this.state.image

        Materialize.toast({
          html: 'Image deleted.',
          displayLength: 3000,
          classes: 'green',
        })
        $(document).trigger('app:image:delete', id)
        if (this.state.onDelete) {
          this.state.onDelete(id)
        }
        if (this.props.onDelete) {
          this.props.onDelete(id)
        }
        Materialize.Modal.getInstance(
          document.getElementById('lightbox-delete-form')
        ).close()
        return Materialize.Modal.getInstance(
          document.getElementById('lightbox')
        ).close()
      },
      error: () => {
        return Materialize.toast({
          html: 'Could not delete that for some reason.',
          displayLength: 3000,
          classes: 'red',
        })
      },
    })
    return e.preventDefault()
  },

  handleClose(e) {
    if (!this.state.image) {
      return
    }

    if (this.state.directLoad) {
      this.props.history.push(this.state.image.character.link)
    } else {
      window.history.back()
    }

    return this.setState({ image: null, onChange: null })
  },

  componentDidMount() {
    $('#lightbox').modal({
      starting_top: '4%',
      ending_top: '10%',
      ready() {
        $(this).find('.autofocus').focus()
        return $(document).trigger('materialize:modal:ready')
      },
      complete: e => {
        return this.handleClose(e)
      },
    })

    return $(document).on('app:lightbox', (e, imageId, onChange, onDelete) => {
      console.debug(
        '[Lightbox] Launching from event with:',
        imageId,
        onChange,
        onDelete
      )

      if (typeof imageId === 'object' && !imageId.comments) {
        imageId = imageId.id
      }

      if (typeof imageId !== 'object') {
        $.ajax({
          url: `/images/${imageId}.json`,
          success: data => {
            this.setState({ image: data, onChange, onDelete })
            return window.history.pushState({}, '', data.path)
          },

          error: error => {
            return this.setState({ error: `Image ${error.statusText}` })
          },
        })
      } else {
        this.setState({
          image: imageId,
          directLoad: imageId.directLoad,
          onChange,
          onDelete,
        })
        window.history.pushState({}, '', imageId.path)
      }

      return Materialize.Modal.getInstance(
        document.getElementById('lightbox')
      ).open()
    })
  },

  _handleChange(image) {
    Materialize.toast({
      html: 'Image saved!',
      displayLength: 3000,
      classes: 'green',
    })
    return this.setState({ image }, this._callback)
  },

  _handleUpdate(image) {
    if (image.background_color) {
      return this.setState({ image })
    }
  },

  _handleComment(comment) {
    if (typeof comment.map !== 'undefined') {
      return StateUtils.updateItems(
        this,
        'image.comments',
        comment,
        'id',
        this._callback
      )
    } else {
      return StateUtils.updateItem(
        this,
        'image.comments',
        comment,
        'id',
        this._callback
      )
    }
  },

  _handleFavorite(favorite, set) {
    if (set == null) {
      set = true
    }
    if (set) {
      return StateUtils.updateItem(
        this,
        'image.favorites',
        favorite,
        'id',
        this._callback
      )
    } else {
      return StateUtils.removeItem(
        this,
        'image.favorites',
        favorite,
        'id',
        this._callback
      )
    }
  },

  _callback() {
    if (!this.state.image) {
      return
    }
    const image = HashUtils.set(
      this.state.image,
      'comments_count',
      this.state.image.comments.length
    )
    ObjectPath.set(image, 'favorites_count', this.state.image.favorites.length)
    console.debug('[Lightbox] Callback with', image)
    if (this.state.onChange) {
      return this.state.onChange(image)
    }
  },

  componentDidUpdate() {
    return $('.dropdown-trigger').dropdown({
      constrain_width: false,
    })
  },

  render() {
    let editable, lightbox
    const poll = true

    if (this.state.image != null) {
      let captionCallback, imgActionMenu
      if (
        this.state.image.user_id ===
        (this.props.currentUser != null
          ? this.props.currentUser.username
          : undefined)
      ) {
        imgActionMenu = (
          <div className="image-action-menu">
            <ul
              id="lightbox-image-actions"
              className="dropdown-content cs-card-background--background-color"
            >
              <li>
                <a href="#" onClick={this.setFeaturedImage}>
                  Set as Cover Image
                </a>
              </li>
              <li>
                <a href="#" onClick={this.setProfileImage}>
                  Set as Profile Image
                </a>
              </li>

              <li className="divider" />

              <li>
                <a href="#image-gravity-modal" className="modal-trigger">
                  <i className="material-icons left">crop</i>
                  <span>Cropping...</span>
                </a>
              </li>

              <li className="divider" />

              <li>
                <a
                  href={this.state.image.path + '/full'}
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <i className="material-icons left">file_download</i>
                  <span>Download</span>
                </a>
              </li>

              <li>
                <a
                  href="#lightbox-delete-form"
                  className="modal-trigger"
                  id="image-delete-link"
                >
                  <i className="material-icons left">delete</i>
                  <span>Delete...</span>
                </a>
              </li>
            </ul>

            <a
              className="dropdown-trigger"
              id="image-actions-menu"
              href="#image-options"
              data-target="lightbox-image-actions"
            >
              <i className="material-icons">more_vert</i>
            </a>
          </div>
        )

        captionCallback = this.handleCaptionChange
        editable = true
      }

      console.log(this.state.image)

      lightbox = (
        <div className="lightbox">
          <div
            className="image-content"
            style={{ backgroundColor: this.state.image.background_color }}
          >
            <img src={this.state.image.url} />
          </div>

          <div className="image-details-container">
            <div className="image-details">
              <div className="image-actions">
                {this.props.currentUser && (
                  <FavoriteButton
                    mediaId={this.state.image.id}
                    favorites={this.state.image.favorites}
                    onFavorite={this._handleFavorite}
                  />
                )}

                {imgActionMenu}
              </div>

              <LightboxCharacterBox
                character={this.state.image.character}
                postDate={this.state.image.post_date}
                nsfw={this.state.image.nsfw}
                hidden={this.state.image.hidden}
              />

              <RichText
                className="image-caption"
                onChange={captionCallback}
                contentHtml={this.state.image.caption_html}
                content={this.state.image.caption}
                placeholder="No caption."
              />

              {this.state.image.source_url && (
                <div className="source-url">
                  <i className="material-icons left">link</i>
                  <a
                    href={this.state.image.source_url}
                    target="_blank"
                    rel="noopener noreferrer"
                  >
                    {this.state.image.source_url_display}
                  </a>
                </div>
              )}

              <div className="source-url">
                <i className="material-icons left">report</i>
                <a
                  href="#report-modal"
                  onClick={this.context.reportImage}
                  data-image-id={this.state.image.id}
                >
                  Report Image
                </a>
              </div>
            </div>

            <Tabs className="comments">
              <Tab
                id="image-comments"
                name="Comments"
                className="padding--none flex-vertical"
                count={this.state.image.comments.length}
              >
                <Comments.Index
                  comments={this.state.image.comments}
                  mediaId={this.state.image.id}
                  onCommentChange={this._handleComment}
                  onCommentsChange={this._handleComment}
                  poll={poll}
                />
              </Tab>

              <Tab
                id="image-favorites"
                name="Favorites"
                count={this.state.image.favorites.length}
              >
                <Favorites.Index
                  favorites={this.state.image.favorites}
                  mediaId={this.state.image.id}
                  onFavoriteChange={this._handleFavorite}
                  poll={poll}
                />
              </Tab>

              {editable && (
                <Tab id="image-settings" icon="settings">
                  <Form
                    model={this.state.image}
                    modelName="image"
                    action={this.state.image.path}
                    onChange={this._handleChange}
                    onUpdate={this._handleUpdate}
                    changeEvent="app:image:update"
                    method="PATCH"
                  >
                    <Input name="title" label="Title" />
                    <Input
                      name="source_url"
                      label="Source URL"
                      hint="This should credit the artist or creator."
                    />
                    <Input
                      name="background_color"
                      type="color"
                      icon=""
                      label="Background Color"
                      hint="Especially useful for transparent images!"
                    />

                    <Row noMargin>
                      <Column s={6}>
                        <Input name="nsfw" type="checkbox" label="NSFW" />
                      </Column>
                      <Column s={6}>
                        <Input name="hidden" type="checkbox" label="Hidden" />
                      </Column>
                    </Row>

                    <Row noMargin>
                      <Column s={6}>
                        <Input
                          name="watermark"
                          type="checkbox"
                          label="Watermark"
                        />
                      </Column>
                    </Row>

                    <div className="right margin-top--large">
                      <Submit>Save Image</Submit>
                    </div>
                  </Form>
                </Tab>
              )}
            </Tabs>
          </div>
        </div>
      )
    } else {
      lightbox = (
        <div className="loader center padding--large">
          {this.state.error ? <h1>{this.state.error}</h1> : <Spinner />}
        </div>
      )
    }

    return (
      <div>
        {editable && (
          <Modal id="lightbox-delete-form" title="Delete Image">
            <p>Are you sure? This can't be undone.</p>
            <Row className="actions margin-top--large">
              <Column>
                <div className="right">
                  <a
                    href="#"
                    className="btn red right"
                    onClick={this.handleDelete}
                    id="image-delete-confirm"
                  >
                    DELETE IMAGE
                  </a>
                </div>

                <a
                  href="#"
                  className="btn"
                  onClick={function (e) {
                    $('#lightbox-delete-form').modal('close')
                    e.preventDefault()
                  }}
                >
                  Cancel
                </a>
              </Column>
            </Row>
          </Modal>
        )}

        {editable && <ImageGravityModal image={this.state.image} />}

        <Modal
          className="lightbox-modal"
          id="lightbox"
          title={this.state.image && this.state.image.title}
          noContainer
        >
          {lightbox}
        </Modal>
      </div>
    )
  },
})

export default compose(withCurrentUser(), withRouter)(Lightbox)
