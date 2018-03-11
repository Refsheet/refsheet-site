import PropTypes from 'prop-types'

Header = ({character}) ->
  `<PageHeader backgroundImage={ (character.featured_image || {}).url }>
    <CharacterNotice transfer={ character.pending_transfer } />
    <CharacterCard detailView={ true } character={ character } />
    <SwatchPanel swatches={ character.swatches } />
  </PageHeader>`

Header.propTypes =
  character: PropTypes.object.isRequired

export default Header
