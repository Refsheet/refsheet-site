import React, { Component } from 'react';
import PropTypes from 'prop-types';
import {Container, Row, Col} from 'react-materialize';
import {ThemeProvider} from 'styled-components';
import Header from './Header';
import Profile from './Profile';
import Gallery from './Gallery';
import Sidebar from './Sidebar';
import defaultTheme from 'themes/default';
import {StickyContainer} from 'react-sticky';
import {ThemedMain} from 'Styled/Global';
import UploadModal from 'Image/UploadModal';
import SettingsModal from "./Modals/SettingsModal";
import ColorModal from "./Modals/ColorModal";

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editable: false,
      settingsOpen: false,
      colorOpen: false
    }

    this.handleEditableChange = this.handleEditableChange.bind(this)
  }

  handleEditableChange(editable) {
    this.setState({editable})
  }

  handleModalOpen(modal) {
    return () => {
      let state = {}
      state[modal + "Open"] = true
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
    const {character, uploadOpen, onChange, onUploadModalOpen, onUploadModalClose} = this.props
    const {settingsOpen, colorOpen} = this.state

    return (
      <ThemedMain title={character.name}>
        {uploadOpen && <UploadModal
          characterId={character.id}
          onClose={onUploadModalClose}
          onUpload={onChange}
        /> }

        { settingsOpen && <SettingsModal onClose={this.handleModalClose('settings').bind(this)} /> }
        { colorOpen && <ColorModal onClose={this.handleModalClose('color').bind(this)} /> }

        <div id='top' className='profile-scrollspy'>
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
                  refetch={this.props.onChange}
                  onSettingsClick={this.handleModalOpen('settings').bind(this)}
                  onColorClick={this.handleModalOpen('color').bind(this)}
                />
              </Col>
              <Col s={12} m={9} l={10}>
                <Profile
                  profileSections={character.profile_sections}
                  editable={this.state.editable}
                  refetch={this.props.onChange}
                  characterId={this.props.character.shortcode}
                />

                {/*<Reference />*/}
                <Gallery images={character.images} onUploadClick={onUploadModalOpen} />
              </Col>
            </Row>
          </StickyContainer>
        </Container>
      </ThemedMain>
    )
  }
}

const Themed = function (props) {
  const {colors} = props.character.theme || {};
  return <ThemeProvider theme={defaultTheme.apply(colors)}>
    <View {...props} />
  </ThemeProvider>;
}

View.propTypes = {
  character: PropTypes.object.isRequired,
  onUploadModalOpen: PropTypes.func,
  onUploadModalClose: PropTypes.func,
  onUpload: PropTypes.func
}

export default Themed;
