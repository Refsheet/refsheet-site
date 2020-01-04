import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { ChromePicker } from 'react-color'
import {withNamespaces} from "react-i18next";
import compose from "../../../../utils/compose";
// import Modal from Global

class ColorModal extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    const { t } = this.props

    return (
      <Modal
        autoOpen
        sideSheet
        id="character-color"
        title={t('labels.edit_color_scheme', 'Edit Color Scheme')}
        onClose={this.props.onClose}
      >

        <ChromePicker disableAlpha />
      </Modal>
    )
  }
}

ColorModal.propTypes = {
  onClose: PropTypes.func,
}

export default compose(
  withNamespaces('common'),
)(ColorModal)
