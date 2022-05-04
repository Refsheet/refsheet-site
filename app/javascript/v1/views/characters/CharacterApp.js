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
import Gallery from '../../../components/Character/Gallery'
import { Query } from 'react-apollo'
import getCharacterImages from './getCharacterImages.graphql'
import Flash from '../../../utils/Flash'
import { ThemedMain } from '../../../components/Styled/Global'
import defaultTheme from '../../../themes/default'
import { ThemeProvider } from 'styled-components'
import ColorUtils from '../../../utils/ColorUtils'
import compose, { withCurrentUser } from '../../../utils/compose'
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
    eagerLoad: PropTypes.object,
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
    characterId: 'slug',
    userId: 'user_id',
  },

  componentDidUpdate(prevProps, prevState) {
    StateUtils.reload(this, 'character', this.props, prevProps)

    if (
      this.state.character &&
      (prevState.character || {}).id !== (this.state.character || {}).id
    ) {
      this.props.setUploadTarget(this.state.character.id)

      // Handle URL changes:
      if (
        prevState.character &&
        prevState.character.link !== this.state.character.link
      )
        window.history.replaceState({}, '', this.state.character.link)
    }
  },

  componentDidMount() {
    StateUtils.load(this, 'character')

    if (this.state.character) {
      this.props.setUploadTarget(this.state.character.id)
    }

    return $(document)
      .on('app:character:update', (e, character) => {
        console.warn('jQuery events are deprecated, find a better way.', e)
        if (this.state.character.id === character.id) {
          return this.setState({ character })
        }
      })
      .on('app:character:profileImage:edit', e => {
        console.warn('jQuery events are deprecated, find a better way.', e)
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
          console.warn('jQuery events are deprecated, find a better way.', e)
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
    $(document).off('app:image:delete')
  },

  setFeaturedImage(imageId) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: this.state.character.path,
        type: 'PATCH',
        data: { character: { featured_image_guid: imageId } },
        success: data => {
          Flash.info('Header image updated!')
          this.setState({ character: data })
          resolve(data)
        },
        error: error => {
          const { errors } = error.responseJSON
          if (errors.featured_image && errors.featured_image.length) {
            Flash.error(errors.featured_image.join(', '))
          } else {
            console.error(error)
            Flash.error('Unknown issue!' + JSON.stringify(errors))
          }
          reject(errors)
        },
      })
    })
  },

  setProfileImage(imageId) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: this.state.character.path,
        type: 'PATCH',
        data: { character: { profile_image_guid: imageId } },
        success: data => {
          Flash.info('Profile picture updated!')
          this.setState({ character: data })
          resolve(data)
        },
        error: error => {
          if (error.responseJSON) {
            const { errors } = error.responseJSON
            if (errors.profile_image && errors.profile_image.length) {
              Flash.error(errors.profile_image.join(', '))
            } else {
              console.error(error)
              Flash.error('Unknown issue: ' + JSON.stringify(errors))
            }
            reject(errors)
          } else {
            reject({ error })
          }
        },
      })
    })
  },

  handleRichTextChange(data) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: this.state.character.path,
        data: { character: data },
        type: 'PATCH',
        success: data => {
          this.setState({ character: data })
          resolve(data)
        },
        error: error => {
          reject(error)
        },
      })
    })
  },

  handleHeaderImageEdit() {
    this.setState({
      galleryTitle: 'Select Header Image',
      onGallerySelect: imageId => {
        this.setFeaturedImage(imageId).then(_data => {
          Materialize.Modal.getInstance(
            document.getElementById('image-gallery-modal')
          ).close()
        })
      },
    })
    return Materialize.Modal.getInstance(
      document.getElementById('image-gallery-modal')
    ).open()
  },

  _toggleEditable() {
    return this.setState({ editable: !this.state.editable })
  },

  _openUploads() {
    return this.props.openUploadModal({
      characterId: this.state.character && this.state.character.id,
    })
  },

  renderGallery(canEdit) {
    return ({ data, loading, error }) => {
      if (error) {
        console.error('renderGallery failed:', error)
      }

      const images =
        (data && data.getCharacterByUrl && data.getCharacterByUrl.images) || []
      const folders =
        (data &&
          data.getCharacterByUrl &&
          data.getCharacterByUrl.media_folders) ||
        []

      return (
        <div>
          <ImageGalleryModal
            v2Data
            images={images}
            title={this.state.galleryTitle}
            onClick={this.state.onGallerySelect}
            onUploadClick={this._openUploads}
          />

          <Gallery
            characterId={this.state.character.id}
            folders={folders}
            images={images}
            loading={loading}
            editable={canEdit}
          />
        </div>
      )
    }
  },

  render() {
    let richTextChange, editable, headerImageEditCallback, showMenu

    if (this.state.error != null) {
      return <NotFound />
    }

    if (!this.state.character) {
      return <CharacterViewSilhouette />
    }

    if (this.state.character.version === 2) {
      let props = this.props

      props.match.params = {
        ...props.match.params,
        username: props.match.params.userId,
        slug: props.match.params.characterId,
      }

      return <Character {...props} />
    }

    const isOwner =
      this.state.character.user_id === (this.props.currentUser || {}).username
    const canEdit =
      isOwner || (this.props.currentUser && this.props.currentUser.is_admin)

    if (canEdit) {
      showMenu = true

      if (this.state.editable) {
        editable = true
        richTextChange = this.handleRichTextChange
        headerImageEditCallback = this.handleHeaderImageEdit
      }
    }

    let colors =
      this.state.character.color_scheme &&
      this.state.character.color_scheme.color_data &&
      ColorUtils.indifferent(this.state.character.color_scheme.color_data)

    return (
      <ThemeProvider theme={defaultTheme.apply(colors || {})}>
        <ThemedMain title={[this.state.character.name, 'Characters']}>
          {colors && <PageStylesheet colorData={colors} />}
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

              <CharacterColorSchemeModal
                colorScheme={{ color_data: colors }}
                characterPath={this.state.character.path}
                onChange={data =>
                  this.setState(
                    {
                      character: {
                        ...this.state.character,
                        color_scheme: {
                          ...this.state.character.color_scheme,
                          color_data: data,
                        },
                      },
                    },
                    console.log
                  )
                }
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
              <Column m={12} id={'profile_about'}>
                <RichText
                  renderAsCard
                  name="profile"
                  title={`About ${this.state.character.name}`}
                  placeholder="No biography written."
                  onChange={richTextChange}
                  contentHtml={this.state.character.profile_html || ''}
                  content={this.state.character.profile}
                />
              </Column>
            </Row>
            <Row className="rowfix">
              <Column m={6} id={'profile_likes'}>
                <RichText
                  renderAsCard
                  title={'Likes'}
                  name={'likes'}
                  placeholder="No likes specified."
                  onChange={richTextChange}
                  contentHtml={this.state.character.likes_html || ''}
                  content={this.state.character.likes}
                />
              </Column>
              <Column m={6} id={'profile_dislikes'}>
                <RichText
                  renderAsCard
                  title={'Dislikes'}
                  name={'dislikes'}
                  placeholder="No dislikes specified."
                  onChange={richTextChange}
                  contentHtml={this.state.character.dislikes_html || ''}
                  content={this.state.character.dislikes}
                />
              </Column>
            </Row>
          </Section>

          <Section className="margin-bottom--large">
            <Query
              query={getCharacterImages}
              variables={{
                slug: this.state.character.slug,
                username: this.state.character.user_id,
              }}
            >
              {this.renderGallery(canEdit)}
            </Query>
          </Section>
        </ThemedMain>
      </ThemeProvider>
    )
  },
})

const mapDispatchToProps = {
  setUploadTarget,
  openUploadModal,
}

const mapStateToProps = state => state

export default compose(
  withCurrentUser(),
  connect(mapStateToProps, mapDispatchToProps)
)(Component)
