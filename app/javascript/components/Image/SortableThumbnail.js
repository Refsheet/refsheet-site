import React, { Component, createRef } from 'react'
import PropTypes from 'prop-types'
import { DragPreviewImage, DragSource, DropTarget } from 'react-dnd'
import Thumbnail from './Thumbnail'
import compose from '../../utils/compose'
import { connect } from 'react-redux'
import { disableDropzone, enableDropzone } from '../../actions'
import styled from 'styled-components'
import Spinner from '../../v1/shared/material/Spinner'

// TODO: Move this to constants somewhere nice.
const Types = {
  THUMBNAIL: 'thumbnail',
}

const SavingOverlay = styled.div`
  position: absolute;
  width: 100%;
  top: 0;
  height: 100%;
  z-index: 99;
  background-color: rgba(0, 0, 0, 0.3);

  & > div {
    top: calc(50% - 32px);
  }
`

const DragPlaceholder = styled.div`
  width: 3px;
  height: 100%;
  position: absolute;
  background-color: ${props => props.theme.primary};

  &.before {
    left: -9px;
  }

  &.after {
    right: -9px;
  }

  &:before,
  &:after {
    display: block;
    position: absolute;
    content: '';
    left: -2px;
    width: 7px;
    border-left: 2px solid transparent;
    border-right: 2px solid transparent;
  }

  &:before {
    top: -5px;
    border-top: 5px solid ${props => props.theme.primary};
  }

  &:after {
    bottom: -5px;
    border-bottom: 5px solid ${props => props.theme.primary};
  }
`

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
    const { dropBefore } = this.state

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
      canDrop,
      moving,
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
        {isOver && canDrop && (
          <DragPlaceholder className={dropBefore ? 'before' : 'after'} />
        )}
        {moving && (
          <SavingOverlay>
            <Spinner />
          </SavingOverlay>
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
      return { id: image.id, type: Types.THUMBNAIL }
    },

    endDrag({ enableDropzone }, monitor, component) {
      enableDropzone()
      if (!monitor.didDrop()) {
        return
      }

      // When dropped on a compatible target, do something
      // const item = monitor.getItem()
      // const dropResult = monitor.getDropResult()
      // console.log('Dropped: ', { item, dropResult })
    },
  },
  dropTarget: {
    canDrop(props, monitor) {
      const item = monitor.getItem()
      return item.type === Types.THUMBNAIL && item.id !== props.image.id
    },

    hover(props, monitor, component) {
      const thumbRef = component.thumbRef
      const clientOffset = monitor.getClientOffset()
      const item = monitor.getItem()

      if (thumbRef.current && clientOffset) {
        const { x } = clientOffset
        const { left, width } = thumbRef.current.getBoundingClientRect()
        const dropBefore = x < left + width / 2
        item.dropBefore = dropBefore
        component.setDropBefore(dropBefore)
      }
    },

    drop(props, monitor, component) {
      if (monitor.didDrop()) {
        return
      }

      const { image, onImageSort } = props

      // Obtain the dragged item
      const item = monitor.getItem()

      // You can do something with it
      const result = {
        targetImageId: image.id,
        sourceImageId: item.id,
        dropBefore: item.dropBefore,
      }
      onImageSort && onImageSort(result)
      return result
    },
  },
  dragCollect(connect, monitor) {
    return {
      connectDragSource: connect.dragSource(),
      connectDragPreview: connect.dragPreview(),
      isDragging: monitor.isDragging(),
    }
  },
  dropCollect(connect, monitor) {
    return {
      connectDropTarget: connect.dropTarget(),
      isOver: monitor.isOver(),
      isOverCurrent: monitor.isOver({ shallow: true }),
      canDrop: monitor.canDrop(),
      itemType: monitor.getItemType(),
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
  moving: PropTypes.bool,
  style: PropTypes.object,
  isDragging: PropTypes.bool,
  enableDropzone: PropTypes.func,
  disableDropzone: PropTypes.func,
  connectDragSource: PropTypes.func,
  connectDropTarget: PropTypes.func,
  connectDragPreview: PropTypes.func,
  onImageSort: PropTypes.func,
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
