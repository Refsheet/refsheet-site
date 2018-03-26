import { PropTypes } from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import Measure from 'react-measure'
import Section from 'Shared/Section'

Gallery = ({images}) ->
  galleryTabs = [
    { id: 'baz', title: 'Baz' }
    { id: 'bar', title: 'Bar' }
  ]

  `<Section title='Main Gallery'
            id='gallery'
            tabs={galleryTabs}
            onTabClick={(id) => console.log(id)}>
    <Measure bounds>
      { renderGallery(images) }
    </Measure>
  </Section>`


renderGallery = (images) -> ({measureRef, contentRect}) ->
  width = contentRect.bounds.width

  imageTiles = images.map ({id, aspect_ratio: aspectRatio, url, size}) ->
    style = size.small

    `<img key={id}
          aspectRatio={aspectRatio}
          src={url.small}
          style={style}
          className='responsive-img block black z-depth-1' />`

  `<div className='gallery-sizer margin-top--medium' ref={measureRef}>
    <JustifiedLayout containerWidth={ width } containerPadding={ 0 }>
      { imageTiles }
    </JustifiedLayout>
  </div>`


Gallery.propTypes =
  images: PropTypes.arrayOf(
    PropTypes.shape(
      id: PropTypes.string.isRequired
      aspect_ratio: PropTypes.number.isRequired
      url: PropTypes.shape(
        small: PropTypes.string.isRequired
      ).isRequired
      size: PropTypes.shape(
        small: PropTypes.shape(
          width: PropTypes.number.isRequired
          height: PropTypes.number.isRequired
        ).isRequired
      ).isRequired
    )
  )

export default Gallery
