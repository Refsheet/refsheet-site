import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Container, Row, Col } from 'react-materialize'
import { ThemeProvider } from 'styled-components'
import Header from './Header'
import Profile from './Profile'
import Gallery from './Gallery'
import Sidebar from './Sidebar'
import defaultTheme from 'themes/default'
import { StickyContainer } from 'react-sticky'
import { ThemedMain } from 'Styled/Global'
import SettingsModal from './Modals/SettingsModal'
import ColorModal from './Modals/ColorModal'
import compose from '../../utils/compose'
import { connect } from 'react-redux'
import { setUploadTarget } from '../../actions'

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editable: false,
      settingsOpen: false,
      colorOpen: false,
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

  handleEditableChange(editable) {
    this.setState({ editable })

    if (!editable) {
      this.props.refetch()
    }
  }

  handleModalOpen(modal) {
    return () => {
      let state = {}
      state[modal + 'Open'] = true
      this.setState(state)
    }
  }

  handleModalClose(modal) {
    return () => {
      let state = {}
      state[modal + 'Open'] = false
      this.setState(state)
    }
  }

  render() {
    const { character, refetch } = this.props
    const { settingsOpen, colorOpen } = this.state

    return (
      <ThemedMain title={character.name}>
        {settingsOpen && (
          <SettingsModal
            onClose={this.handleModalClose('settings').bind(this)}
            character={character}
            refetch={refetch}
          />
        )}
        {colorOpen && (
          <ColorModal onClose={this.handleModalClose('color').bind(this)} />
        )}

        <div id="top" className="profile-scrollspy">
          <Header character={character} editable={this.state.editable} />
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
                  characterId={character.shortcode}
                  refetch={this.props.refetch}
                  onSettingsClick={this.handleModalOpen('settings').bind(this)}
                  onColorClick={this.handleModalOpen('color').bind(this)}
                  canEdit={character.can_edit}
                />
              </Col>
              <Col s={12} m={9} l={10}>
                <Profile
                  profileSections={character.profile_sections}
                  editable={this.state.editable}
                  refetch={this.props.refetch}
                  characterId={this.props.character.shortcode}
                />

                {/*<Reference />*/}
                <Gallery images={character.images} />
              </Col>
            </Row>
          </StickyContainer>
        </Container>
      </ThemedMain>
    )
  }
}

const Themed = function(props) {
  const { colors } = props.character.theme || {}
  return (
    <ThemeProvider theme={defaultTheme.apply(colors)}>
      <View {...props} />
    </ThemeProvider>
  )
}

View.propTypes = {
  character: PropTypes.object.isRequired,
  onUpload: PropTypes.func,
}

const mapDispatchToProps = {
  setUploadTarget,
}

export default compose(connect(undefined, mapDispatchToProps))(Themed)
