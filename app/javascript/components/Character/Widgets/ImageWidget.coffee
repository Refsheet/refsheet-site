import PropTypes from 'prop-types'

ImageWidget = ({ imageSrc, alt, caption }) ->
  `<div className='image-widget'>
    <img src={ imageSrc } alt={ alt } className='responsive-img block'/>

    { caption && caption.length > 0 &&
      <div className='image-caption muted card-content'>{ caption }</div> }
  </div>`

ImageWidget.propTypes =
  imageSrc: PropTypes.string.isRequired
  alt: PropTypes.string
  caption: PropTypes.string

export default ImageWidget
