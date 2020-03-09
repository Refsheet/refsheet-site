import { PropTypes } from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import Measure from 'react-measure'
import Section from 'Shared/Section'
import Thumbnail from 'Image/Thumbnail'
import compose from "../../utils/compose"
import {connect} from "react-redux"
import {openUploadModal} from "../../actions"

Gallery = ({images, openUploadModal}) ->
  galleryTabs = [
    { id: 'baz', title: 'Scraps' }
    { id: 'bar', title: 'Hidden' }
  ]

  galleryActions = [
    { icon: 'file_upload', title: 'Upload', onClick: openUploadModal }
  ]

  `<Section title='Main Gallery'
            id='gallery'
            className='profile-scrollspy'
            tabs={galleryTabs}
            buttons={galleryActions}
            onTabClick={(id) => console.log(id)}>
    <Measure bounds>
      { renderGallery(images) }
    </Measure>
  </Section>`


renderGallery = (images) -> ({measureRef, contentRect}) ->
  width = contentRect.bounds.width

  gallery = images.map (i) ->
    i.id

  imageTiles = images.map (image) ->
    {id, aspect_ratio} = image

    `<Thumbnail key={id} aspectRatio={aspect_ratio || 1} image={image} gallery={gallery} />`

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

mapDispatchToProps = {
  openUploadModal
}

export default compose(
  connect(undefined, mapDispatchToProps)
)(Gallery)
