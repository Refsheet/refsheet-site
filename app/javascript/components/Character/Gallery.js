/* eslint-disable
    react/prop-types,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import { PropTypes } from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import Measure from 'react-measure'
import Section from 'Shared/Section'
import Thumbnail from 'Image/Thumbnail'
import compose from '../../utils/compose'
import { connect } from 'react-redux'
import { openUploadModal } from '../../actions'

const Gallery = function({ images, openUploadModal }) {
  const galleryTabs = [
    { id: 'baz', title: 'Scraps' },
    { id: 'bar', title: 'Hidden' },
  ]

  const galleryActions = [
    { icon: 'file_upload', title: 'Upload', onClick: openUploadModal },
  ]

  return (
    <Section
      title="Main Gallery"
      id="gallery"
      className="profile-scrollspy"
      tabs={galleryTabs}
      buttons={galleryActions}
      onTabClick={id => console.log(id)}
    >
      <Measure bounds>{renderGallery(images)}</Measure>
    </Section>
  )
}

var renderGallery = images =>
  function({ measureRef, contentRect }) {
    const { width } = contentRect.bounds

    const gallery = images.map(i => i.id)

    const imageTiles = images.map(function(image) {
      const { id, aspect_ratio } = image

      return (
        <Thumbnail
          key={id}
          aspectRatio={aspect_ratio || 1}
          image={image}
          gallery={gallery}
        />
      )
    })

    return (
      <div className="gallery-sizer margin-top--medium" ref={measureRef}>
        <JustifiedLayout containerWidth={width} containerPadding={0}>
          {imageTiles}
        </JustifiedLayout>
      </div>
    )
  }

Gallery.propTypes = {
  images: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      aspect_ratio: PropTypes.number.isRequired,
      url: PropTypes.shape({
        small: PropTypes.string.isRequired,
      }).isRequired,
      size: PropTypes.shape({
        small: PropTypes.shape({
          width: PropTypes.number.isRequired,
          height: PropTypes.number.isRequired,
        }).isRequired,
      }).isRequired,
    })
  ),
}

const mapDispatchToProps = {
  openUploadModal,
}

export default compose(connect(undefined, mapDispatchToProps))(Gallery)
