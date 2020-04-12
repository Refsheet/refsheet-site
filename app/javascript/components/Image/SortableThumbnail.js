import React, { Component, createRef, Fragment, useEffect, useRef } from 'react'
import PropTypes from 'prop-types'
import { DragPreviewImage, DragSource, DropTarget } from 'react-dnd'
import Thumbnail from './Thumbnail'
import compose from '../../utils/compose'
import { connect } from 'react-redux'
import { disableDropzone, enableDropzone } from '../../actions'

// TODO: Move this to constants somewhere nice.
const Types = {
  THUMBNAIL: 'thumbnail',
}

/**
 * Sortable wrapper around the standard image Thumbnail component. Works well in
 * JustifiedLayout galleries.
 */
class SortableThumbnail extends Component {
  constructor(props) {
    super(props)

    this.state = {
      dropBefore: false,
    }

    this.thumbRef = createRef()
  }

  componentDidUpdate(oldProps) {
    const { isDragging } = this.props

    if (oldProps.isDragging !== isDragging) {
      if (isDragging) {
        disableDropzone()
      } else {
        enableDropzone()
      }
    }
  }

  /**
   * Try not to use this inappropriately. It exists so that the drag/drop helpers can update the
   * state within hover().
   * @param dropBefore
   */
  setDropBefore(dropBefore) {
    if (dropBefore === this.state.dropBefore) return
    this.setState({ dropBefore })
  }

  render() {
    const {
      dropBefore
    } = this.state

    // Obtain a copy of our child params
    const {
      image: { id, url },
      style: propsStyle = {},
    } = this.props

    // Splice out non-child params and collect the rest
    const {
      isDragging,
      clientOffset,
      isOver,
      connectDragSource,
      connectDropTarget,
      connectDragPreview,
      ...thumbnailProps
    } = this.props

    const style = {
      ...propsStyle,
      opacity: isDragging ? 0.5 : 1,
    }

    const connector = c => connectDragSource(connectDropTarget(c))

    return (
      <Thumbnail
        {...thumbnailProps}
        style={style}
        connectorFunc={connector}
        innerRef={this.thumbRef}
      >
        {isOver && (
          <div
            style={{
              left: dropBefore ? 0 : '50%',
              width: '50%',
              height: '100%',
              position: 'absolute',
              backgroundColor: 'rgba(0,0,0,0.1)',
            }}
          >
            Move { dropBefore ? "before" : "after" } this image.
          </div>
        )}
        <DragPreviewImage
          src={url.thumbnail || url.small_square}
          data-image-id={id}
          connect={connectDragPreview}
        />
      </Thumbnail>
    )
  }
}

/**
 * Functions related to react-dnd connections defined later.
 */
const DragHelpers = {
  dragSource: {
    beginDrag({ image, disableDropzone }) {
      disableDropzone()
      // Return the data describing the dragged item
      const item = { id: image.id, type: Types.THUMBNAIL }
      return item
    },

    endDrag({ enableDropzone }, monitor, component) {
      enableDropzone()
      if (!monitor.didDrop()) {
        return
      }

      // When dropped on a compatible target, do something
      const item = monitor.getItem()
      const dropResult = monitor.getDropResult()
      console.log('Dropped: ', { item, dropResult })
    },
  },
  dropTarget: {
    canDrop(props, monitor) {
      // You can disallow drop based on props or item
      const item = monitor.getItem()
      return item.type === Types.THUMBNAIL
    },

    hover(props, monitor, component) {
      const thumbRef = component.thumbRef
      const clientOffset = monitor.getClientOffset()

      if (thumbRef.current && clientOffset) {
        const { x } = clientOffset
        const { left, width } = thumbRef.current.getBoundingClientRect()
        const dropBefore = x < left + (width / 2)
        component.setDropBefore(dropBefore)
      }
    },

    drop(props, monitor, component) {
      if (monitor.didDrop()) {
        // If you want, you can check whether some nested
        // target already handled drop
        return
      }

      const { image } = props

      // Obtain the dragged item
      const item = monitor.getItem()

      // You can do something with it
      console.log('Dropped in Target: ', { image, item })

      // You can also do nothing and return a drop result,
      // which will be available as monitor.getDropResult()
      // in the drag source's endDrag() method
      return { sortBefore: image.id }
    },
  },
  dragCollect(connect, monitor) {
    return {
      // Call this function inside render()
      // to let React DnD handle the drag events:
      connectDragSource: connect.dragSource(),
      connectDragPreview: connect.dragPreview(),
      // You can ask the monitor about the current drag state:
      isDragging: monitor.isDragging(),
    }
  },
  dropCollect(connect, monitor) {
    return {
      // Call this function inside render()
      // to let React DnD handle the drag events:
      connectDropTarget: connect.dropTarget(),
      // You can ask the monitor about the current drag state:
      isOver: monitor.isOver(),
      isOverCurrent: monitor.isOver({ shallow: true }),
      canDrop: monitor.canDrop(),
      itemType: monitor.getItemType(),
      dropBefore: false,
    }
  },
}

SortableThumbnail.propTypes = {
  image: PropTypes.shape({
    id: PropTypes.string.isRequired,
    url: PropTypes.shape({
      thumbnail: PropTypes.string,
      small_square: PropTypes.string.isRequired,
    }),
  }).isRequired,
  style: PropTypes.object,
  isDragging: PropTypes.bool,
  enableDropzone: PropTypes.func,
  disableDropzone: PropTypes.func,
  connectDragSource: PropTypes.func,
  connectDropTarget: PropTypes.func,
  connectDragPreview: PropTypes.func,
}

const mapDispatchToProps = {
  enableDropzone,
  disableDropzone,
}

// Export the wrapped version
export default compose(
  connect(undefined, mapDispatchToProps),
  DragSource(Types.THUMBNAIL, DragHelpers.dragSource, DragHelpers.dragCollect),
  DropTarget(Types.THUMBNAIL, DragHelpers.dropTarget, DragHelpers.dropCollect)
)(SortableThumbnail)
