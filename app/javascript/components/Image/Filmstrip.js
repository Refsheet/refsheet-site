import React from 'react'
import PropTypes from 'prop-types'
import { Component } from 'react'

class Filmstrip extends Component {
  constructor(props) {
    super(props)

    this.filmstripRef = null
    this.activeImageRef = null

    this.renderImage = this.renderImage.bind(this)
    this.imageClickHandler = this.imageClickHandler.bind(this)
  }

  select(id) {
    if (this.props.onSelect) this.props.onSelect(id)
  }

  componentDidUpdate() {
    const filmstrip = this.filmstripRef
    const activeImage = this.activeImageRef

    const requestAnimationFrame =
      requestAnimationFrame || (s => setTimeout(s, 1000 / 60))

    if (activeImage) {
      const left = activeImage.offsetLeft + activeImage.width / 2
      const width = filmstrip.clientWidth / 2
      const finalScroll = Math.max(left - width, 0)
      let current = filmstrip.scrollLeft
      const distance = finalScroll - current
      const steps = 10
      let count = 0

      const step = () => {
        current += distance / steps
        count++
        filmstrip.scrollLeft = current
        if (count < steps) requestAnimationFrame(step)
      }

      requestAnimationFrame(step)
    }
  }

  imageClickHandler(id) {
    return e => {
      this.select(id)
      e.preventDefault()
    }
  }

  renderImage({ src, id, state, progress }) {
    const classNames = ['filmstrip-image']
    const active = this.props.activeImageId === id
    if (active) classNames.push('active')

    return (
      <div className={classNames.join(' ')} key={id}>
        <img
          src={src}
          key={id}
          data-id={id}
          onClick={this.imageClickHandler(id)}
          ref={r => active && (this.activeImageRef = r)}
        />

        {state === 'uploading' && (
          <div className="progress-overlay" style={{ width: `${progress}%` }} />
        )}
      </div>
    )
  }

  render() {
    const { images = [], autoHide } = this.props

    if (images.length === 0 && autoHide) return null

    return (
      <div className="filmstrip" ref={r => (this.filmstripRef = r)}>
        {images.map(this.renderImage)}
      </div>
    )
  }
}

const imageType = PropTypes.shape({
  src: PropTypes.string.isRequired,
  id: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
  active: PropTypes.bool,
  state: PropTypes.string.isRequired,
  progress: PropTypes.number,
})

Filmstrip.propTypes = {
  images: PropTypes.arrayOf(imageType),
  autoHide: PropTypes.bool,
  onSelect: PropTypes.func,
}

export default Filmstrip
