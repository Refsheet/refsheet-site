import PropTypes from 'prop-types'
import Header from './Header'
import Profile from './Profile'
import Gallery from './Gallery'

View = ({character, onChange}) ->
  `<Main title={ character.name }>
    <PageStylesheet colorData={ character.color_scheme.color_data } />
    <Header character={character} />
    <Profile character={character} onChange={onChange}/>
    <Gallery images={character.images} />
  </Main>`

View.propTypes =
  character: PropTypes.object.isRequired
  onChange: PropTypes.func

export default View
