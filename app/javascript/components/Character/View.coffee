import React from 'react'
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
import UploadModal from 'Image/UploadModal'

View = ({character}) ->
  console.log {character}
  `<ThemedMain title={ character.name }>
    <UploadModal characterId={ character.id } />

    <div id='top' className='profile-scrollspy'>
      <Header character={character} />
    </div>

    <Container>
      <StickyContainer>
        <Row>
          <Col s={12} m={3} l={2}>
            <Sidebar user={character.user} profileSections={character.profile_sections} />
          </Col>
          <Col s={12} m={9} l={10}>
            <Profile profileSections={character.profile_sections} />
            {/*<Reference />*/}
            <Gallery images={character.images} />
          </Col>
        </Row>
      </StickyContainer>
    </Container>
  </ThemedMain>`

Themed = (props) ->
  { colors } = props.character.theme || {}
  `<ThemeProvider theme={defaultTheme.apply(colors)}>
    <View {...props} />
  </ThemeProvider>`

View.propTypes =
  character: PropTypes.object.isRequired

export default Themed
