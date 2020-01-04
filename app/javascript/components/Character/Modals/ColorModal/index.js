import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { ChromePicker } from 'react-color'
import { withNamespaces } from 'react-i18next'
import compose from '../../../../utils/compose'
// import Modal from Global

class ColorModal extends Component {
  constructor(props) {
    super(props)
  }

  handleClose() {
    this.props.onChange(this.props.colorScheme)
    this.props.onClose()
  }

  render() {
    const { t, colorSchemeOverride } = this.props

    console.log(this.props)

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
  colorScheme: PropTypes.object,
  colorSchemeOverride: PropTypes.object,
  onChange: PropTypes.func,
}

export default compose(withNamespaces('common'))(ColorModal)
