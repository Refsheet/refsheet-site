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
import ColorTheme from '../../../../utils/ColorTheme'
// import Modal from Global

// TODO: Move simple / advanced to tabs
// TODO: Cleanup callback hell.
// TODO: Calculate additional values off of base colors
// TODO: Refactor focus to 3 main color groups: Accent, Text & Background

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

  theme(colors = this.props.colorSchemeOverride.colors) {
    return new ColorTheme({ ...colors, base: this.state.base })
  }

  extrapolateColors(key, colors) {
    if (this.state.mode === 'advanced') return colors
    return this.theme(colors).getHash()
  }

  applyBaseColors() {
    const base = this.simpleBase[this.state.base]
    const _this = this
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
      suggestion = this.theme().getSuggestions({
        base: 'brand',
        includeBase: 'background',
        desaturate: 0.4,
        darken: 0.7,
        lighten: 2.3,
        count: 7,
      })
    } else if (key.match(/text/i)) {
      suggestion = this.theme().getSuggestions({
        base: 'brand',
        includeBase: 'text',
        desaturate: 0.4,
        darken: 0.6,
        lighten: 0.4,
        count: 7,
        highContrast: true,
      })
    } else {
      suggestion = this.theme().getSuggestions({ base: 'brand', count: 14 })
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
              width={232}
              presetColors={suggestion}
              onChangeComplete={this.handleColorChange(key).bind(this)}
            />
          ) : (
            <TwitterPicker
              color={color}
              width={240}
              colors={suggestion}
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
