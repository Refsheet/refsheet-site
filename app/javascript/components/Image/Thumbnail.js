import React from 'react'
import PropTypes from 'prop-types'

const Thumbnail = ({image, style}) => {
  const { url, title, aspect_ratio, image_processing } = image
  const { small: src } = url

  const renderImage = () => {
    if (image_processing) {
      return (<div className='message center-align'>
        <div className='caption margin-top--large'>Image processing...</div>
        <div className='muted margin-top--medium'>
          Thumbnails are being generated for this image, and should be available soon.
          You might need to reload this page.
        </div>
      </div>)

    } else if (!aspect_ratio) {
      return (<div className='message center-align'>
        <div className='caption margin-top--large red-text'>Invalid image :(</div>
        <div className='muted margin-top--medium'>
          Something's not quite right. This might be a bug. Report Image #{image.id}.
        </div>
      </div>)

    } else {
      return (<img src={ src } className='responsive-img block' alt={ title }/>)
    }
  }

  return (<div style={style} className='image-thumbnail black z-depth-1'>
    { renderImage() }
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
    }).isRequired,
    image_processing: PropTypes.bool
  })
}

export default Thumbnail
