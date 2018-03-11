import PropTypes from 'prop-types'
import Header from './Header'

View = ({character}) ->
  `<Main title={ character.name }>
    <PageStylesheet colorData={ character.color_scheme.color_data } />
    <Header character={character} />
  </Main>`

View.propTypes =
  character: PropTypes.object.isRequired

export default View
