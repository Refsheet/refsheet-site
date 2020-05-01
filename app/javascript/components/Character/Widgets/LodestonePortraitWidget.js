import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Caption } from '../../Styled/Caption'

class LodestonePortraitWidget extends Component {
  render() {
    const {
      character: { lodestone_character },
    } = this.props

    if (!lodestone_character) {
      return (
        <Caption className={'center card-content'}>No Lodestone Link!</Caption>
      )
    }

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
