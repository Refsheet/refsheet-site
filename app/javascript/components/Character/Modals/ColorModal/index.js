import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { BlockPicker, ChromePicker, TwitterPicker } from 'react-color'
import { withNamespaces } from 'react-i18next'
import compose from '../../../../utils/compose'
// import Modal from Global

const colorSuggestions = {
  accent: [
    '#26a69a', // teal lighten-1 brand-primary
    '#00838f', // cyan darken-3
    '#0277bd', // light-blue darken-3
    '#1565c0', // blue darken-3
    '#283593', // indigo darken-3
    '#4527a0', // deep-purple darken-3
    '#6a1b9a', // purple darken-3
    '#ad1457', // pink darken-3
    '#c62828', // red darken-3
    '#d84315', // deep-orange darken-3
    '#ef6c00', // orange darken-3
    '#6d4c41', // brown darken-1
  ],
  background: [
    '#262626',
    '#212121',
    '#000000',
    '#EEEEEE',
    '#F6F6F6',
    '#FFFFFF',
  ],
  text: ['#FFFFFF', '#bdbdbd', '#757575', '#444444', '#212121', '#000000'],
}

class ColorModal extends Component {
  constructor(props) {
    super(props)
  }

  handleClose() {
    this.props.onChange(this.props.colorScheme)
    this.props.onClose()
  }

  handleColorChange(key) {
    return color => {
      let theme = { ...this.props.colorSchemeOverride }
      let colors = { ...theme.colors }
      colors[key] = color.hex
      theme.colors = colors
      this.props.onChange(theme)
    }
  }

  renderColor(key) {
    if (['__typename'].indexOf(key) !== -1) return

    const {
      t,
      colorScheme,
      colorSchemeOverride: { colors },
    } = this.props

    const color = colors[key] || ''
    let suggestion

    if (key.match(/background/i)) {
      suggestion = colorSuggestions.background
    } else if (key.match(/text/i)) {
      suggestion = colorSuggestions.text
    } else {
      suggestion = colorSuggestions.accent
    }

    return (
      <div key={key} className={'color-picker'}>
        <label>{key}</label>
        <TwitterPicker
          color={color}
          width={200}
          colors={[colorScheme.colors[key], ...suggestion]}
          onChangeComplete={this.handleColorChange(key).bind(this)}
        />
      </div>
    )
  }

  render() {
    const { t, colorSchemeOverride } = this.props

    return (
      <Modal
        autoOpen
        sideSheet
        id="character-color"
        title={t('labels.edit_color_scheme', 'Edit Color Scheme')}
        onClose={this.props.onClose}
      >
        {Object.keys(colorSchemeOverride.colors).map(
          this.renderColor.bind(this)
        )}
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
