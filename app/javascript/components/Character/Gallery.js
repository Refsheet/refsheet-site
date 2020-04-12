import React from 'react'
import PropTypes from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import Measure from 'react-measure'
import Section from 'components/Shared/Section'
import Thumbnail from 'components/Image/Thumbnail'
import compose from '../../utils/compose'
import { DragSource, DropTarget } from 'react-dnd'
import { connect } from 'react-redux'
import { openUploadModal } from '../../actions'
import SortableThumbnail from '../Image/SortableThumbnail'

function convertData(images) {
  return images.map(image => ({
    ...image,
    url: {
      small: image.small,
      medium: image.medium,
      large: image.large,
    },
  }))
}

const Gallery = function({ v1Data, noHeader, images, openUploadModal }) {
  let imageData = images

  if (v1Data) {
    imageData = convertData(images)
  }

  if (noHeader) {
    return <Measure bounds>{renderGallery(imageData)}</Measure>
  }

  const galleryTabs = [
    // { id: 'baz', title: 'Scraps' },
    // { id: 'bar', title: 'Hidden' },
  ]

  const galleryActions = [
    {
      icon: 'file_upload',
      title: 'Upload',
      id: 'galleryUpload',
      onClick: openUploadModal,
    },
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
      <Measure bounds>{renderGallery(imageData)}</Measure>
    </Section>
  )
}

const renderGallery = images =>
  function({ measureRef, contentRect }) {
    const { width } = contentRect.bounds

    const gallery = images.map(i => i.id)

    const imageTiles = images.map(function(image) {
      const { id, aspect_ratio } = image

      return (
        <SortableThumbnail
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
  v1Data: PropTypes.bool,
  noHeader: PropTypes.bool,
  loading: PropTypes.bool,
  folders: PropTypes.arrayOf(
    PropTypes.shape({
      name: PropTypes.string,
      id: PropTypes.string,
      slug: PropTypes.string,
      description: PropTypes.string,
    })
  ),
  images: PropTypes.arrayOf(
    PropTypes.shape({
      id: PropTypes.string.isRequired,
      aspect_ratio: PropTypes.number,
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
