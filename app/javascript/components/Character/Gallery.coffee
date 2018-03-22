import { PropTypes } from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import Measure from 'react-measure'
import Section from 'Shared/Section'

Gallery = ({images}) ->
  galleryTabs = [
    { id: 'baz', title: 'Baz' }
    { id: 'bar', title: 'Bar' }
  ]

  `<Section title='Main Gallery' id='gallery' tabs={galleryTabs} onTabClick={(id) => console.log(id)} measured>
    <Measure bounds>
      { renderGallery(images) }
    </Measure>
  </Section>`


renderGallery = (images) -> ({measureRef, contentRect}) ->
  { bounds } = contentRect
  { width } = bounds

  imageTiles = images.map ({id, aspect_ratio: aspectRatio, small, width, height}) ->
    style = { width, height }

    `<img key={id}
          aspectRatio={aspectRatio}
          src={small} 
          style={style}
          className='responsive-img block black z-depth-1' />`

  `<div className='gallery-sizer margin-top--medium' ref={measureRef}>
    <JustifiedLayout containerWidth={ width } containerPadding={ 0 }>
      { imageTiles }
    </JustifiedLayout>
  </div>`


Gallery.propTypes =
  images: PropTypes.arrayOf(PropTypes.object)

export default Gallery
