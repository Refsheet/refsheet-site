import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Row, Col, Icon, TextInput, Switch, Tabs, Tab } from 'react-materialize'
import { withNamespaces } from 'react-i18next'
import compose, { withMutations } from '../../../../utils/compose'
import ColorTheme from '../../../../utils/ColorTheme'
import Modal from 'Styled/Modal'
import Input from '../../../../v1/shared/forms/Input'
import updateColorScheme from './updateColorScheme.graphql'

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

    this.themeLabels = {
      primary: 'Primary Color',
      accent1: 'Secondary Color',
      accent2: 'Accent Color',
      text: 'Main Text',
      textMedium: 'Muted Text',
      textLight: 'Subtle Text',
      background: 'Page Background',
      cardBackground: 'Card Background',
      cardHeaderBackground: 'Card Header',
      border: 'Border Colors',
      imageBackground: 'Image Background',
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
        text: '#323232',
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
    this.handleColorChanges({ background: base.background, text: base.text })
  }

  handleClose() {
    this.props.onChange(this.props.colorScheme)
    this.props.onClose()
  }

  handleColorChanges(changes) {
    let theme = { ...this.props.colorSchemeOverride }
    let colors = { ...theme.colors }

    Object.keys(changes).map(key => {
      colors[key] = changes[key]
      theme.colors = this.extrapolateColors(key, colors)
    })

    this.props.onChange(theme)
  }

  handleColorChange(key, value) {
    let theme = { ...this.props.colorSchemeOverride }
    let colors = { ...theme.colors }
    colors[key] = value
    theme.colors = this.extrapolateColors(key, colors)

    this.props.onChange(theme)
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

    const {
      updateColorScheme,
      colorScheme: { id },
      colorSchemeOverride: { colors: colorData },
    } = this.props

    updateColorScheme({
      wrapped: true,
      variables: {
        id,
        colorData,
      },
    })
      .then(console.log)
      .catch(console.error)
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
      suggestion = this.theme().getSuggestions({
        base: 'brand',
        includeBase: 'background',
        desaturate: 0.4,
        darken: 0.7,
        lighten: 2.3,
        count: 6,
      })
    } else if (key.match(/text/i)) {
      suggestion = this.theme().getSuggestions({
        base: 'brand',
        includeBase: 'text',
        desaturate: 0.4,
        darken: 0.6,
        lighten: 0.4,
        count: 6,
        highContrast: true,
      })
    } else {
      suggestion = this.theme().getSuggestions({ base: 'brand', count: 14 })
    }

    return (
      <Input
        type={'color'}
        colors={suggestion}
        id={`theme_${key}`}
        name={key}
        key={key}
        label={t(`colorScheme.${key}`, this.themeLabels[key])}
        value={color}
        onChange={this.handleColorChange.bind(this)}
        s={8}
      />
    )
  }

  render() {
    const { t, colorSchemeOverride } = this.props
    const advanced = this.state.mode === 'advanced'
    const light = this.state.base === 'light'

    const actions = [
      {
        name: 'Save',
        action: this.handleSubmit.bind(this),
      },
    ]

    return (
      <Modal
        autoOpen
        sideSheet
        id="character-color"
        title={t('labels.edit_color_scheme', 'Edit Color Scheme')}
        onClose={this.handleClose.bind(this)}
        actions={actions}
      >
        <form onSubmit={this.handleSubmit.bind(this)}>
          <div className={'margin-bottom--large'}>
            <div className={'center margin-bottom--medium'}>
              <Switch
                id={'theme_advanced'}
                offLabel={'Simple'}
                onLabel={'Advanced'}
                onChange={this.changeMode.bind(this)}
                checked={advanced}
              />
            </div>
            {!advanced && (
              <div className={'margin-bottom--medium center'}>
                <Switch
                  id={'theme_light'}
                  offLabel={'Dark'}
                  onLabel={'Light'}
                  onChange={this.changeBase.bind(this)}
                  checked={light}
                />
              </div>
            )}
          </div>
          <div className={'margin-top--large'}>
            {this.colorKeys[this.state.mode].map(this.renderColor.bind(this))}
          </div>
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

export default compose(
  withNamespaces('common'),
  withMutations({
    updateColorScheme,
  })
)(ColorModal)
