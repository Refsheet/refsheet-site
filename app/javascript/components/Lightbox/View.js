import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'

class View extends Component {
  constructor(props) {
    super(props)
  }

  handlePrevClick(e) {
    e.preventDefault()
    this.props.onMediaOpen(this.props.prevMediaId)
  }

  handleNextClick(e) {
    e.preventDefault()
    this.props.onMediaOpen(this.props.nextMediaId)
  }

  render() {
    const {
      title,
      url: {
        large: imageSrc
      },
      nextMediaId,
      prevMediaId
    } = this.props

    return (
      <div className={'lightbox-content'}>
        <div className={'image-content'}>
          { prevMediaId && <a className={'image-prev image-nav'} href={`/images/${prevMediaId}`} onClick={this.handlePrevClick.bind(this)}>
            <Icon>keyboard_arrow_left</Icon>
          </a> }

          { nextMediaId && <a className={'image-next image-nav'} href={`/images/${nextMediaId}`} onClick={this.handleNextClick.bind(this)}>
            <Icon>keyboard_arrow_right</Icon>
          </a> }

          <img src={imageSrc} alt={title} title={title} />
        </div>

        <div className={'image-details-container'}>
          <div className='image-details'>
            { JSON.stringify(this.props) }
          </div>
        </div>
      </div>
    )
  }
}

View.propTypes = {
  onMediaOpen: PropTypes.func.isRequired
}

export default View