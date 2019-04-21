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

class View extends Component {
  constructor(props) {
    super(props)

    this.state = {
      editable: false
    }

    this.handleEditableChange = this.handleEditableChange.bind(this)
  }

  handleEditableChange(editable) {
    this.setState({editable})
  }

  render() {
    const {character, uploadOpen, onChange, onUploadModalOpen, onUploadModalClose} = this.props

    return (
      <ThemedMain title={character.name}>
        {uploadOpen &&
        <UploadModal
          characterId={character.id}
          onClose={onUploadModalClose}
          onUpload={onChange}
        />}

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
                />
              </Col>
              <Col s={12} m={9} l={10}>
                <Profile profileSections={character.profile_sections} editable={this.state.editable} refetch={this.props.onChange} />
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
