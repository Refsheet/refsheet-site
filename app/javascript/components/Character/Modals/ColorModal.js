import React, { Component } from 'react'
import PropTypes from 'prop-types'

class ColorModal extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <Modal autoOpen id='character-color' title={'Character Color'} onClose={this.props.onClose} />
    )
  }
}

ColorModal.propTypes = {
  onClose: PropTypes.func
}

export default ColorModal