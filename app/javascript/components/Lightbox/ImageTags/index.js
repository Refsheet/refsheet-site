import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import c from 'classnames'
import { Link } from 'react-router-dom'

class ImageTags extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  renderTag(tag, i) {
    const left = tag.position_x < 50
    const top = tag.position_y < 50

    return (
      <li
        key={i}
        className={c('tag', { left, right: !left, top, bottom: !top })}
        style={{
          left: left ? `${tag.position_x}%` : 'auto',
          right: left ? 'auto' : `${100 - tag.position_x}%`,
          top: top ? `${tag.position_y}%` : 'auto',
          bottom: top ? 'auto' : `${100 - tag.position_y}%`,
        }}
      >
        <Link to={'/'}>
          <img
            className={'avatar circle'}
            src={'/administrator/test.png'}
            alt={tag.character.name}
          />
          <span>{tag.character.name}</span>
        </Link>
      </li>
    )
  }

  render() {
    const { tags } = this.props

    return (
      <ul className={'image-tags'}>{tags.map(this.renderTag.bind(this))}</ul>
    )
  }
}

ImageTags.propTypes = { tags: PropTypes.array.isRequired }

export default compose()(ImageTags)
// TODO: Add HOC bindings here
