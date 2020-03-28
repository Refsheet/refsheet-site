/* do-not-disable-eslint
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { openUploadModal, setUploadTarget } from '../../../actions'
import Section from '../../shared/material/Section'
import ImageGallery from '../../shared/images/ImageGallery'
import Column from '../../shared/material/Column'
import Row from '../../shared/material/Row'
import SwatchPanel from '../../shared/swatches/SwatchPanel'
import CharacterCard from './CharacterCard'
import ActionButton from '../../shared/ActionButton'
import CharacterNotice from './CharacterNotice'
import PageHeader from '../../shared/PageHeader'
import CharacterSettingsModal from '../../shared/modals/character/CharacterSettingsModal'
import CharacterTransferModal from './CharacterTransferModal'
import CharacterDeleteModal from '../../shared/modals/character/CharacterDeleteModal'
import CharacterColorSchemeModal from '../../shared/modals/character/CharacterColorSchemeModal'
import ImageGalleryModal from '../../shared/modals/ImageGalleryModal'
import FixedActionButton from '../../shared/FixedActionButton'
import PageStylesheet from '../../shared/PageStylesheet'
import NotFound from '../static/NotFound'
import * as Materialize from 'materialize-css'
import Main from '../../shared/Main'
import CharacterViewSilhouette from './CharacterViewSilhouette'
import RichText from '../../../components/Shared/RichText'
import Character from 'components/Character'
import $ from 'jquery'
import StateUtils from '../../utils/StateUtils'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Component = createReactClass({
  contextTypes: {
    router: PropTypes.object.isRequired,
    eagerLoad: PropTypes.object,
    currentUser: PropTypes.object,
  },

  getInitialState() {
    return {
      character: null,
      error: null,
      galleryTitle: null,
      onGallerySelect: null,
      images: null,
      editable: true,
    }
  },

  dataPath: '/users/:userId/characters/:characterId',
  paramMap: {
    characterId: 'id',
    userId: 'user_id',
  },

  UNSAFE_componentWillMount() {
    return StateUtils.load(this, 'character')
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    return StateUtils.reload(this, 'character', newProps)
  },

  componentDidMount() {
    this.props.setUploadTarget(
      this.state.character != null ? this.state.character.real_id : undefined
    )

    return $(document)
      .on('app:character:update', (e, character) => {
        if (this.state.character.real_id === character.real_id) {
          return this.setState({ character })
        }
      })
      .on('app:character:profileImage:edit', () => {
        this.setState({
          galleryTitle: 'Select Profile Picture',
          onGallerySelect: imageId => {
            this.setProfileImage(imageId)
            return Materialize.Modal.getInstance(
              document.getElementById('image-gallery-modal')
            ).close()
          },
        })
        return Materialize.Modal.getInstance(
          document.getElementById('image-gallery-modal')
        ).open()
      })
      .on(
        'app:character:reload app:image:delete',
        (e, newPath, callback = null) => {
          if (newPath == null) {
            newPath = this.state.character.path
          }
          console.debug('[CharacterApp] Reloading character...')
          return $.get(`${newPath}.json`, data => {
            this.setState({ character: data })
            if (callback != null) {
              return callback(data)
            }
          })
        }
      )
  },

  componentWillUnmount() {
    $(document).off('app:character:update')
    $(document).off('app:character:profileImage:edit')
    $(document).off('app:character:reload')
    return $(document).off('app:image:delete')
  },

  UNSAFE_componentWillUpdate(newProps, newState) {
    if (
      newState.character &&
      this.state.character &&
      newState.character.link !== this.state.character.link
    ) {
      window.history.replaceState({}, '', newState.character.link)
      return this.props.setUploadTarget(
        this.state.character != null ? this.state.character.real_id : undefined
      )
    }
  },

  setFeaturedImage(imageId) {
    return $.ajax({
      url: this.state.character.path,
      type: 'PATCH',
      data: { character: { featured_image_guid: imageId } },
      success: data => {
        Materialize.toast({
          html: 'Cover image changed!',
          displayLength: 3000,
          classes: 'green',
        })
        return this.setState({ character: data })
      },
      error: error => {
        const { errors } = error.responseJSON
        return Materialize.toast({
          html: errors.featured_image,
          displayLength: 3000,
          classes: 'red',
        })
      },
    })
  },

  setProfileImage(imageId) {
    return $.ajax({
      url: this.state.character.path,
      type: 'PATCH',
      data: { character: { profile_image_guid: imageId } },
      success: data => {
        Materialize.toast({
          html: 'Profile image changed!',
          displayLength: 3000,
          classes: 'green',
        })
        return this.setState({ character: data })
      },
      error: error => {
        const { errors } = error.responseJSON
        return Materialize.toast({
          html: errors.profile_image,
          displayLength: 3000,
          classes: 'red',
        })
      },
    })
  },

  handleProfileChange(data, onSuccess, onError) {
    return $.ajax({
      url: this.state.character.path,
      data: { character: { profile: data } },
      type: 'PATCH',
      success: data => {
        this.setState({ character: data })
        return onSuccess()
      },
      error: error => {
        return onError(error)
      },
    })
  },

  handleLikesChange(data, onSuccess, onError) {
    return $.ajax({
      url: this.state.character.path,
      data: { character: { likes: data } },
      type: 'PATCH',
      success: data => {
        this.setState({ character: data })
        return onSuccess()
      },
      error: error => {
        return onError(error)
      },
    })
  },

  handleDislikesChange(data, onSuccess, onError) {
    return $.ajax({
      url: this.state.character.path,
      data: { character: { dislikes: data } },
      type: 'PATCH',
      success: data => {
        this.setState({ character: data })
        return onSuccess()
      },
      error: error => {
        return onError(error)
      },
    })
  },

  handleHeaderImageEdit() {
    this.setState({
      galleryTitle: 'Select Header Image',
      onGallerySelect: imageId => {
        this.setFeaturedImage(imageId)
        return Materialize.Modal.getInstance(
          document.getElementById('image-gallery-modal')
        ).close()
      },
    })
    return Materialize.Modal.getInstance(
      document.getElementById('image-gallery-modal')
    ).open()
  },

  handleDropzoneUpload(data) {
    const i = this.state.images
    i.push(data)
    return this.setState({ images: i })
  },

  _handleGalleryLoad(data) {
    return this.setState({ images: data })
  },

  _toggleEditable() {
    return this.setState({ editable: !this.state.editable })
  },

  _openUploads() {
    return this.props.openUploadModal()
  },

  render() {
    let dislikesChange,
      editable,
      headerImageEditCallback,
      likesChange,
      profileChange,
      showMenu
    if (this.state.error != null) {
      return <NotFound />
    }

    if (this.state.character == null) {
      return <CharacterViewSilhouette />
    }

    if (this.state.character.version === 2) {
      let props = this.props

      props.match.params = {
        ...props.match.params,
        username: props.match.params.userId,
        slug: props.match.params.characterId,
      }

      console.log("V2 in V1 bodge. Reverse this direction soon.", { props });
      return <Character {...props} />
    }

    if (
      this.state.character.user_id ===
      (this.context.currentUser != null
        ? this.context.currentUser.username
        : undefined)
    ) {
      showMenu = true

      if (this.state.editable) {
        editable = true
        const dropzoneUpload = this.handleDropzoneUpload
        profileChange = this.handleProfileChange
        likesChange = this.handleLikesChange
        dislikesChange = this.handleDislikesChange
        headerImageEditCallback = this.handleHeaderImageEdit
        const dropzoneTriggerId = ['#image-upload']
      }
    }

    return (
      <Main title={[this.state.character.name, 'Characters']}>
        {this.state.character.color_scheme && (
          <PageStylesheet
            colorData={this.state.character.color_scheme.color_data}
          />
        )}

        {/*<CharacterEditMenu onEditClick={ this._toggleEditable }
                              images={ this.state.images }
                              galleryTitle={ this.state.galleryTitle } <-- THIS SHOULD NOT HAPPEN
                              onGallerySelect={ this.onGallerySelect }
                              character={ this.state.character } */}

        {showMenu && (
          <div className="edit-container">
            <FixedActionButton
              clickToToggle
              className="red"
              tooltip="Menu"
              icon="menu"
            >
              <ActionButton
                className="indigo lighten-1"
                tooltip="Upload Images"
                id="image-upload"
                onClick={this._openUploads}
                icon="file_upload"
              />
              <ActionButton
                className="green lighten-1 modal-trigger"
                tooltip="Edit Page Colors"
                href="#color-scheme-form"
                icon="palette"
              />
              <ActionButton
                className="blue darken-1 modal-trigger"
                tooltip="Character Settings"
                href="#character-settings-form"
                icon="settings"
              />

              {editable ? (
                <ActionButton
                  className="red lighten-1"
                  tooltip="Lock Page"
                  icon="lock"
                  onClick={this._toggleEditable}
                />
              ) : (
                <ActionButton
                  className="red lighten-1"
                  tooltip="Edit Page"
                  icon="edit"
                  onClick={this._toggleEditable}
                />
              )}
            </FixedActionButton>

            <ImageGalleryModal
              images={this.state.images}
              title={this.state.galleryTitle}
              onClick={this.state.onGallerySelect}
              onUploadClick={this._openUploads}
            />

            <CharacterColorSchemeModal
              colorScheme={this.state.character.color_scheme}
              characterPath={this.state.character.path}
            />
            <CharacterDeleteModal character={this.state.character} />
            <CharacterTransferModal character={this.state.character} />
            <CharacterSettingsModal character={this.state.character} />
          </div>
        )}

        <PageHeader
          backgroundImage={(this.state.character.featured_image || {}).url}
          onHeaderImageEdit={headerImageEditCallback}
        >
          <CharacterNotice transfer={this.state.character.pending_transfer} />

          {showMenu && (
            <div className="button-group">
              {editable ? (
                <ActionButton
                  className="red lighten-1"
                  tooltip="Lock Page"
                  icon="lock"
                  onClick={this._toggleEditable}
                />
              ) : (
                <ActionButton
                  className="red lighten-1"
                  tooltip="Edit Page"
                  icon="edit"
                  onClick={this._toggleEditable}
                />
              )}
            </div>
          )}

          <CharacterCard
            edit={editable}
            detailView={true}
            character={this.state.character}
            onLightbox={this.props.onLightbox}
          />
          <SwatchPanel
            edit={editable}
            swatchesPath={this.state.character.path + '/swatches/'}
            swatches={this.state.character.swatches}
          />
        </PageHeader>

        <Section>
          <Row className="rowfix">
            <Column m={12}>
              <div className="card-panel margin--none">
                <h1>About {this.state.character.name}</h1>
                <RichText
                  placeholder="No biography written."
                  onChange={profileChange}
                  content={this.state.character.profile_html}
                  markup={this.state.character.profile}
                />
              </div>
            </Column>
          </Row>
          <Row className="rowfix">
            <Column m={6}>
              <div className="card-panel margin--none">
                <h2>Likes</h2>
                <RichText
                  placeholder="No likes specified."
                  onChange={likesChange}
                  content={this.state.character.likes_html}
                  markup={this.state.character.likes}
                />
              </div>
            </Column>
            <Column m={6}>
              <div className="card-panel margin--none">
                <h2>Dislikes</h2>
                <RichText
                  placeholder="No dislikes specified."
                  onChange={dislikesChange}
                  content={this.state.character.dislikes_html}
                  markup={this.state.character.dislikes}
                />
              </div>
            </Column>
          </Row>
        </Section>

        <Section className="margin-bottom--large">
          <ImageGallery
            editable={editable}
            imagesPath={this.state.character.path + '/images/'}
            images={this.state.images}
            onImagesLoad={this._handleGalleryLoad}
          />
        </Section>
      </Main>
    )
  },
})

const mapDispatchToProps = {
  setUploadTarget,
  openUploadModal,
}

const mapStateToProps = state => state

const CharacterApp = connect(mapStateToProps, mapDispatchToProps)(Component)
export default CharacterApp
