import PropTypes from 'prop-types'
import {Component} from 'react'
// TODO: Import React once we're done with the global nonsense.

class Filmstrip extends Component {
  static findDefaultActive(images) {
    if(!images || images.length === 0) return
    const markedActive = images.filter((i) => i.active)

    if(markedActive.length === 0) {
      return images[0].id
    }

    return markedActive[0].id
  }

  constructor(props) {
    super(props)

    this.state = {
      activeImageId: Filmstrip.findDefaultActive(props.images)
    }

    this.renderImage = this.renderImage.bind(this)
    this.imageClickHandler = this.imageClickHandler.bind(this)
  }

  select(id) {
    this.setState({activeImageId: id})
    if(this.props.onSelect) this.props.onSelect(id)
  }

  componentWillReceiveProps(newProps) {
    if(typeof this.state.activeImageId === 'undefined' && newProps.images.length > 0) {
      const defaultActive = Filmstrip.findDefaultActive(newProps.images)
      this.select(defaultActive)
    }
  }

  componentDidUpdate() {
    const {
      filmstrip,
      activeImage
    } = this.refs

    const requestAnimationFrame = requestAnimationFrame || ((s) => setTimeout(s, 1000 / 60))

    if(activeImage) {
      const left = activeImage.offsetLeft + (activeImage.width / 2)
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
        if(count < steps) requestAnimationFrame(step)
      }

      requestAnimationFrame(step)
    }
  }

  imageClickHandler(id) {
    return (e) => {
      this.select(id)
      e.preventDefault()
    }
  }

  renderImage({src, id}) {
    const classNames = []
    const active = this.state.activeImageId === id
    if(active) classNames.push('active')

    return <img src={src}
                key={id}
                data-id={id}
                onClick={this.imageClickHandler(id)}
                ref={active ? 'activeImage' : null}
                className={classNames.join(' ')} />
  }

  render() {
    const {
      images = [],
      autoHide
    } = this.props

    if(images.length === 0 && autoHide)
      return null

    return <div className='filmstrip' ref='filmstrip'>
      { images.map(this.renderImage) }
    </div>
  }
}

const imageType = {
  src: PropTypes.string.isRequired,
  id: PropTypes.string.isRequired,
  active: PropTypes.boolean
}

Filmstrip.propTypes = {
  images: PropTypes.arrayOf(imageType),
  autoHide: PropTypes.boolean,
  onSelect: PropTypes.func
}

export default Filmstrip
