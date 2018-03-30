import PropTypes from 'prop-types'

Header = ({character}) ->
  `<PageHeader backgroundImage={ (character.featured_image || {url:{}}).url.large }>
    <CharacterCard detailView={ true } character={ character } />
  </PageHeader>`

Header.propTypes =
  character: PropTypes.object.isRequired

export default Header
