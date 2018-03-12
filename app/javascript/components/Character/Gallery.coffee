import { PropTypes } from 'prop-types'

Gallery = ({images}) ->
  `<p>Gallery</p>`

Gallery.propTypes =
  images: PropTypes.arrayOf(PropTypes.object)

export default Gallery
