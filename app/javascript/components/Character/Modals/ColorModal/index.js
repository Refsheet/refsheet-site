import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Row, Col, Icon, TextInput, Switch } from 'react-materialize'
import {
  BlockPicker,
  ChromePicker,
  SketchPicker,
  TwitterPicker,
} from 'react-color'
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

// TODO: Refactor dark/light detection based on background color selection, move bg before text
// TODO: Move simple / advanced to tabs
// TODO: Cleanup callback hell.
// TODO: Adjust text / bg suggestions to values appropriate for the base selection & colors
// TODO: Calculate additional values off of base colors
// TODO: Refactor focus to 3 main color groups: Accent, Text & Background
// TODO: Refactor color calculations to utility class.

class ColorModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      mode: 'simple',
      base: 'dark',
    }

    this.colorKeys = {
      simple: ['primary', 'text', 'background'],

      advanced: [
        'primary',
        'accent1',
        'accent2',
        'text',
        'textLight',
        'textMedium',
        'background',
        'cardBackground',
        'imageBackground',
      ],
    }

    this.simpleBase = {
      dark: {
        text: '#bdbdbd',
        background: '#262626',
      },
      light: {
        text: '#212121',
        background: '#eeeeee',
      },
    }
  }

  extrapolateColors(key, colors) {
    if (this.state.mode === 'advanced') return colors

    switch (key) {
      case 'primary':
        colors['accent1'] = colors['accent2'] = colors['primary']
        break
      case 'text':
        colors['textLight'] = colors['textMedium'] = colors['text']
        break
      case 'background':
        colors['cardBackground'] = colors['imageBackground'] =
          colors['background']
    }

    return colors
  }

  applyBaseColors() {
    const base = this.simpleBase[this.state.base]
    const _this = this
    console.log(base)
    this.handleColorChange('background')({ hex: base.background }, () => {
      _this.handleColorChange.bind(_this)('text')({ hex: base.text })
    })
  }

  handleClose() {
    this.props.onChange(this.props.colorScheme)
    this.props.onClose()
  }

  handleColorChange(key) {
    return (color, callback) => {
      let theme = { ...this.props.colorSchemeOverride }
      let colors = { ...theme.colors }
      colors[key] = color.hex
      theme.colors = this.extrapolateColors(key, colors)
      this.props.onChange(
        theme,
        typeof callback === 'object' ? undefined : callback
      )
    }
  }

  changeMode(e) {
    this.setState({ mode: e.target.checked ? 'advanced' : 'simple' })
  }

  changeBase(e) {
    this.setState({ base: e.target.checked ? 'light' : 'dark' }, () => {
      this.applyBaseColors()
    })
  }

  handleSubmit(e) {
    e.preventDefault()
  }

  renderColor(key) {
    if (['__typename'].indexOf(key) !== -1) return

    const {
      t,
      colorScheme,
      colorSchemeOverride: { colors },
    } = this.props

    const advanced = this.state.mode === 'advanced'

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
      <Row key={key} className={'color-picker'}>
        <TextInput
          id={`theme_${key}`}
          name={key}
          label={key}
          value={color}
          readOnly
          s={8}
        />
        <Col s={4}>
          <Icon>grid</Icon>
          <Icon>palette</Icon>
        </Col>
        <Col s={12}>
          {advanced ? (
            <SketchPicker
              color={color}
              width={200}
              presetColors={[colorScheme.colors[key], ...suggestion]}
              onChangeComplete={this.handleColorChange(key).bind(this)}
            />
          ) : (
            <TwitterPicker
              color={color}
              width={200}
              colors={[colorScheme.colors[key], ...suggestion]}
              onChangeComplete={this.handleColorChange(key).bind(this)}
            />
          )}
        </Col>
      </Row>
    )
  }

  render() {
    const { t, colorSchemeOverride } = this.props
    const advanced = this.state.mode === 'advanced'
    const light = this.state.base === 'light'

    return (
      <Modal
        autoOpen
        sideSheet
        id="character-color"
        title={t('labels.edit_color_scheme', 'Edit Color Scheme')}
        onClose={this.props.onClose.bind(this)}
      >
        <form onSubmit={this.handleSubmit.bind(this)}>
          <Switch
            id={'theme_advanced'}
            offLabel={'Simple'}
            onLabel={'Advanced'}
            onChange={this.changeMode.bind(this)}
            checked={advanced}
          />
          {advanced || (
            <Switch
              id={'theme_light'}
              offLabel={'Dark'}
              onLabel={'Light'}
              onChange={this.changeBase.bind(this)}
              checked={light}
            />
          )}
          {this.colorKeys[this.state.mode].map(this.renderColor.bind(this))}
        </form>
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
