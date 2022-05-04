import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Container, Row, Col } from 'react-materialize'
import { ThemeProvider } from 'styled-components'
import Header from './Header'
import Profile from './Profile'
import Gallery from './Gallery'
import Sidebar from './Sidebar'
import { StickyContainer } from 'react-sticky'
import { ThemedMain } from 'Styled/Global'
import SettingsModal from './Modals/SettingsModal'
import ColorModal from './Modals/ColorModal'
import compose from '../../utils/compose'
import { connect } from 'react-redux'
import { setUploadTarget } from '../../actions'
import RevisionModal from './Modals/RevisionModal'
import AvatarModal from './Modals/AvatarModal'
import CoverModal from './Modals/CoverModal'
import themes from '../../themes'
import MarketplaceBuyModal from './Modals/MarketplaceBuyModal'
import Error from '../Shared/Error'

class View extends Component {
  constructor(props) {
    super(props)

    let colorSchemeOverride = this.props.character && this.props.character.theme

    if (!colorSchemeOverride) {
      colorSchemeOverride = {
        id: null,
        colors: themes.dark.base,
      }
    }

    this.state = {
      editable: false,
      colorSchemeOverride,
      settingsOpen: window.location.hash === '#character-settings',
      colorOpen: window.location.hash === '#character-color',
      revisionsOpen: window.location.hash === '#character-revisions',
      uploadAvatarOpen: window.location.hash === '#upload-avatar',
      uploadCoverOpen: window.location.hash === '#upload-avatar',
      marketplaceBuyOpen: window.location.hash === '#marketplace-buy',
    }

    this.handleEditableChange = this.handleEditableChange.bind(this)
  }

  componentDidMount() {
    this.props.setUploadTarget(
      this.props.character.id,
      this.uploadCallback.bind(this)
    )
  }

  // TODO: Upload callback should update the Apollo cache, not force a Refetch. That's brutal.
  uploadCallback(image) {
    this.props.refetch && this.props.refetch()
  }

  handleColorSchemeOverride(theme, callback) {
    this.setState({ colorSchemeOverride: theme }, callback)
  }

  handleEditableChange(editable) {
    this.setState({ editable })

    if (!editable) {
      this.props.refetch()
    }
  }

  handleModalOpen(modal) {
    return e => {
      e && e.preventDefault && e.preventDefault()
      let state = {}
      state[modal + 'Open'] = true
      this.setState(state)
    }
  }

  handleModalClose(modal) {
    return e => {
      e && e.preventDefault && e.preventDefault()
      let state = {}
      state[modal + 'Open'] = false
      this.setState(state)
    }
  }

  /**
   * TODO: Refactor out the modals to their own component.
   * Consider a ModalProvider container/HOC. Yeees.
   * That's complicated and unnecessary this is fine just let it go.
   */
  render() {
    const { character, refetch, session } = this.props

    if (!character) {
      return <Error error={'Character was not found?'} />
    }

    const {
      settingsOpen,
      colorOpen,
      revisionsOpen,
      uploadAvatarOpen,
      uploadCoverOpen,
      marketplaceBuyOpen,
    } = this.state

    const { colors } =
      this.state.colorSchemeOverride || this.props.character.theme || {}

    const theme = themes[session.theme] || themes.dark
    console.log(theme, colors)

    return (
      <ThemeProvider theme={theme.apply(colors)}>
        <ThemedMain title={character.name}>
          {settingsOpen && (
            <SettingsModal
              onClose={this.handleModalClose('settings').bind(this)}
              character={character}
              refetch={refetch}
            />
          )}

          {colorOpen && (
            <ColorModal
              onClose={this.handleModalClose('color').bind(this)}
              colorScheme={character.theme || {}}
              characterId={character.id}
              colorSchemeOverride={this.state.colorSchemeOverride}
              onChange={this.handleColorSchemeOverride.bind(this)}
            />
          )}

          {revisionsOpen && (
            <RevisionModal
              characterId={character.id}
              onClose={this.handleModalClose('revisions').bind(this)}
              onSave={refetch}
            />
          )}

          {uploadAvatarOpen && (
            <AvatarModal
              character={character}
              onSave={refetch}
              onClose={this.handleModalClose('uploadAvatar').bind(this)}
            />
          )}

          {uploadCoverOpen && (
            <CoverModal
              character={character}
              onSave={refetch}
              onClose={this.handleModalClose('uploadCover').bind(this)}
            />
          )}

          {marketplaceBuyOpen && (
            <MarketplaceBuyModal
              character={character}
              onSave={refetch}
              onClose={this.handleModalClose('marketplaceBuy').bind(this)}
            />
          )}

          <div id="top" className="profile-scrollspy">
            <Header
              character={character}
              editable={this.state.editable}
              onHeaderImageEdit={this.handleModalOpen('uploadCover').bind(this)}
              onAvatarEdit={this.handleModalOpen('uploadAvatar').bind(this)}
              onMarketplaceBuy={this.handleModalOpen('marketplaceBuy').bind(
                this
              )}
            />
          </div>

          <Container>
            <StickyContainer>
              <Row>
                <Col s={12} m={3} l={2}>
                  <Sidebar
                    user={character.user}
                    profileSections={character.profile_sections}
                    editable={this.state.editable}
                    onEditableChange={this.handleEditableChange}
                    characterVersion={character.version}
                    characterId={character.id}
                    refetch={this.props.refetch}
                    onSettingsClick={this.handleModalOpen('settings').bind(
                      this
                    )}
                    onColorClick={this.handleModalOpen('color').bind(this)}
                    onRevisionsClick={this.handleModalOpen('revisions').bind(
                      this
                    )}
                    canEdit={character.can_edit}
                  />
                </Col>
                <Col s={12} m={9} l={10}>
                  <Profile
                    profileSections={character.profile_sections}
                    editable={this.state.editable}
                    refetch={this.props.refetch}
                    character={character}
                    characterId={this.props.character.id}
                  />

                  {/*<Reference />*/}
                  <Gallery
                    characterId={character.id}
                    images={character.images}
                    folders={character.media_folders}
                    editable={character.can_edit}
                  />
                </Col>
              </Row>
            </StickyContainer>
          </Container>
        </ThemedMain>
      </ThemeProvider>
    )
  }
}

View.propTypes = {
  character: PropTypes.object.isRequired,
  onUpload: PropTypes.func,
}

const mapDispatchToProps = {
  setUploadTarget,
}

export default compose(
  connect(({ session }) => ({ session }), mapDispatchToProps)
)(View)
