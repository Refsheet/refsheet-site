import React from 'react'
import PropTypes from 'prop-types'
import ProgressiveImage from 'react-progressive-image'

const ImageWidget = ({ imageSrc, alt, caption }) => (
  <div className="image-widget">
    <ProgressiveImage
      src={imageSrc}
      placeholder="https://assets.refsheet.net/assets/logos/RefsheetLogo_White_200.png"
    >
      {(src, loading) => (
        <img
          style={{ opacity: loading ? 0.5 : 1 }}
          src={src}
          alt={alt}
          className="responsive-img block"
        />
      )}
    </ProgressiveImage>

    {caption && caption.length > 0 && (
      <div className="image-caption muted card-content">{caption}</div>
    )}
  </div>
)

ImageWidget.propTypes = {
  imageSrc: PropTypes.string.isRequired,
  alt: PropTypes.string,
  caption: PropTypes.string,
}

export default ImageWidget
