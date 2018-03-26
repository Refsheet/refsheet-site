import React from 'react'
import PropTypes from 'prop-types'
import Header from './Header'
import Profile from './Profile'
import Gallery from './Gallery'

View = ({character}) ->
  `<Main title={ character.name }>
    { character.color_scheme &&
      <PageStylesheet colorData={ character.color_scheme.color_data } /> }

    <Header character={character} />
    <Profile profileSections={character.profile_sections} />
    <Gallery images={character.images} />
  </Main>`

View.propTypes =
  character: PropTypes.object.isRequired

export default View
