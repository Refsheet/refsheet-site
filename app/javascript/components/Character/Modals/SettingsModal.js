import React, { Component } from 'react'
import PropTypes from 'prop-types'

class SettingsModal extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <Modal autoOpen id='character-settings' title={'Character Settings'} onClose={this.props.onClose} />
    )
  }
}

SettingsModal.propTypes = {
  onClose: PropTypes.func
}

export default SettingsModal