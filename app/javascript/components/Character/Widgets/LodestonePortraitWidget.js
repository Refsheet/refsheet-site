import React, { Component } from 'react'
import PropTypes from 'prop-types'

class LodestonePortraitWidget extends Component {
  render() {
    const {
      character: { lodestone_character },
    } = this.props

    return (
      <img
        src={lodestone_character.portrait_url}
        alt={`Lodestone Portrait for ${lodestone_character.name}`}
        className={'responsive-img'}
      />
    )
  }
}

LodestonePortraitWidget.propTypes = {
  character: PropTypes.shape({
    lodestone_character: PropTypes.object,
  }),
}

export default LodestonePortraitWidget
