import React, { useEffect, useState } from 'react'
import PropTypes from 'prop-types'
import JustifiedLayout from 'react-justified-layout'
import Measure from 'react-measure'
import Section from 'components/Shared/Section'
import Thumbnail from 'components/Image/Thumbnail'
import compose, { withMutations } from '../../utils/compose'
import { connect } from 'react-redux'
import { openUploadModal } from '../../actions'
import SortableThumbnail from '../Image/SortableThumbnail'
import gql from 'graphql-tag'
import ArrayUtils from '../../utils/ArrayUtils'

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

const Gallery = function ({
  v1Data,
  noHeader,
  images,
  openUploadModal,
  sortGalleryImage,
  editable,
}) {
  let imageData = images

  const [imageOrder, updateImageOrder] = useState(images.map(i => i.id))
  const [pendingChanges, updatePendingChanges] = useState([])

  useEffect(() => {
    updateImageOrder(images.map(i => i.id))
  }, [images])

  if (v1Data) {
    imageData = convertData(images)
  }

  const onImageSort = ({ targetImageId, sourceImageId, dropBefore }) => {
    // console.log('onImageSort', { targetImageId, sourceImageId, dropBefore })
    if (!editable) {
      return
    }

    updateImageOrder(
      ArrayUtils.move(imageOrder, sourceImageId, targetImageId, dropBefore)
    )

    updatePendingChanges([...pendingChanges, sourceImageId])

    sortGalleryImage({
      wrapped: true,
      variables: {
        targetImageId,
        sourceImageId,
        dropBefore,
      },
    })
      .then(({ data: { sortGalleryImage } }) => {
        updatePendingChanges(
          pendingChanges.slice(pendingChanges.indexOf(sourceImageId), 1)
        )
      })
      .catch(e => {
        console.error(e)
        updateImageOrder(images.map(i => i.id))
      })
  }

  if (noHeader) {
    return (
      <Measure bounds>
        {renderGallery(imageData, onImageSort, imageOrder, pendingChanges)}
      </Measure>
    )
  }

  const galleryTabs = [
    // { id: 'baz', title: 'Scraps' },
    // { id: 'bar', title: 'Hidden' },
  ]

  const galleryActions = [
    editable && {
      icon: 'file_upload',
      title: 'Upload',
      id: 'galleryUpload',
      onClick: openUploadModal,
    },
  ].filter(Boolean)

  return (
    <Section
      title="Main Gallery"
      id="gallery"
      className="profile-scrollspy"
      tabs={galleryTabs}
      buttons={galleryActions}
      onTabClick={id => console.log(id)}
    >
      <Measure bounds>
        {renderGallery(imageData, onImageSort, imageOrder, pendingChanges)}
      </Measure>
    </Section>
  )
}

const renderGallery = (images, onImageSort, imageOrder, pendingChanges) =>
  function ({ measureRef, contentRect }) {
    const { width } = contentRect.bounds

    const sorted = [...images].sort(
      (a, b) => imageOrder.indexOf(a.id) - imageOrder.indexOf(b.id)
    )

    const imageTiles = sorted.map(function (image) {
      const { id, aspect_ratio } = image

      return (
        <SortableThumbnail
          key={id}
          onImageSort={onImageSort}
          aspectRatio={aspect_ratio || 1}
          image={image}
          moving={pendingChanges.indexOf(id) >= 0}
          gallery={imageOrder}
        />
      )
    })

    return (
      <div className="gallery-sizer margin-top--medium" ref={measureRef}>
        <JustifiedLayout
          containerWidth={width}
          boxSpacing={15}
          containerPadding={0}
        >
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
  editable: PropTypes.bool,
}

const mapDispatchToProps = {
  openUploadModal,
}

const sortGalleryImage = gql`
  mutation sortGalleryImage(
    $sourceImageId: ID!
    $targetImageId: ID!
    $dropBefore: Boolean
  ) {
    sortGalleryImage(
      sourceImageId: $sourceImageId
      targetImageId: $targetImageId
      dropBefore: $dropBefore
    ) {
      id
      images {
        id
      }
    }
  }
`

export default compose(
  connect(undefined, mapDispatchToProps),
  withMutations({ sortGalleryImage })
)(Gallery)
