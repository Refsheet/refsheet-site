import React from 'react'
import PropTypes from 'prop-types'
import Summary from './Summary'

Header = ({character}) ->
  `<PageHeader backgroundImage={ (character.featured_image || {url:{}}).url.large }>
    <Summary character={ character } />
  </PageHeader>`

Header.propTypes =
  character: PropTypes.object.isRequired

export default Header
