import react from 'react'
import PropTypes from 'prop-types'

const Thumbnail = ({image, style}) => {
  const { url, title, aspect_ratio } = image
  const { small: src } = url

  return (<div style={style} className='image-thumbnail black z-depth-1'>
    { aspect_ratio
      ? <img src={src} className='responsive-img block' alt={title} />
      : <div className='message center-align caption margin-top--large'>Image processing...</div> }
  </div>)
}

Thumbnail.propTypes = {
  image: PropTypes.shape({
    url: PropTypes.shape({
      small: PropTypes.string.isRequired
    }).isRequired,
    size: PropTypes.shape({
      small: PropTypes.shape({
        width: PropTypes.number.isRequired,
        height: PropTypes.number.isRequired
      }).isRequired
    }).isRequired
  })
}

export default Thumbnail
