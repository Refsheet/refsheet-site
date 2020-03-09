import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default PageStylesheet = createReactClass({
  propTypes: {
    colorData: PropTypes.object.isRequired,
  },

  getInitialState() {
    return { colorData: this.props.colorData }
  },

  componentWillReceiveProps(newProps) {
    return { colorData: this.props.colorData }
  },

  componentDidMount() {
    return $(document).on('app:color_scheme:update', (e, colorData) => {
      return this.setState({ colorData })
    })
  },

  componentWillUnmount() {
    return $(document).off('app:color_scheme:update')
  },

  render() {
    let hasDarkLogo, hasWhiteLogo
    const isDark = function(c) {
      if (c[0] === '#') {
        c = c.substring(1)
      }
      const rgb = parseInt(c, 16)
      const r = (rgb >> 16) & 0xff
      const g = (rgb >> 8) & 0xff
      const b = (rgb >> 0) & 0xff
      const luma = 0.2126 * r + 0.7152 * g + 0.0722 * b
      return luma < 100
    }

    const otherClasses = {
      //== background

      '.cs-background--background-color': [
        'body',
        '.chip, .icon-container',
        '.color-helper',
        '.dropdown-content li:hover',
        '.cp-color-picker',
      ],

      //== text

      '.cs-text--color': ['body', 'nav a'],

      //== text-light

      '.cs-text-light--color': [
        '.attribute-table .actions a',
        '.chip .icon-container',
        '::-moz-placeholder, ::placeholder, ::-webkit-placeholder',
        '.character-meta',
      ],

      //== text-medium

      '.cs-text-medium--color': [
        '.chip',
        'section.pop-out .caption',
        'section.pop-out .rich-text.empty',
        '.default-value',
        'body #rootApp footer',
        'label',
        '.rich-text.empty',
        '.character-details .date',
        '.lightbox .image-actions a',
        'body #rootApp footer .footer-copyright',
        '.source-url i',
      ],

      '.cs-text-medium--background-color': ['.btn.grey.darken-3'],

      //== card-background

      '.cs-card-background--background-color': [
        '.card',
        '.character-card',
        '.slant',
        '.pop-out',
        '.collapsible',
        'nav, body #rootApp footer.page-footer',
        '.lightbox',
        '.modal',
        '.dropdown-content',
        '.card-panel',
        '.material-tooltip',
      ],

      //== primary

      '.cs-primary--color': ['h1', 'a:not(.btn)'],
      '.cs-primary--background-color': ['ul li:before'],

      //== accent1

      '.cs-accent1--background-color': [
        '.btn:not(.btn-flat)',
        'ul.tabs .indicator',
      ],
      '.cs-accent1--color': [
        'h2',
        '.character-card .character-details h2',
        'code',
        'label.active',
      ],
      '.cs-accent1--border-color': ['blockquote'],

      //== accent2

      '.cs-accent2--color': [
        '.attribute-table li:not(.attribute-form) .attribute-data .key',
        'section.pop-out h2',
        'h3',
      ],
      '.cs-accent2--background-color': ['.btn-secondary'],
    }

    let css = ''

    for (let color in this.state.colorData) {
      const value = this.state.colorData[color]
      for (let property of ['background-color', 'color', 'border-color']) {
        let className = `.cs-${color}--${property}`
        const moreClasses =
          otherClasses[className] != null
            ? otherClasses[className].join(', ')
            : undefined
        if (moreClasses) {
          className += `, ${moreClasses}`
        }

        css += `\
${className} {
  ${property}: ${value} !important;
}\n\
`
      }
    }

    if (this.state.colorData['accent1']) {
      css += `\
input:active, textarea:active, input:focus, textarea:focus {
  border-bottom: 1px solid ${this.state.colorData['accent1']} !important;
  box-shadow: 0 1px 0 0 ${this.state.colorData['accent1']} !important;
}\
`
    }

    const addlCssLight = `\
.logo img, .patreon img {
  filter: brightness(0) invert(1);
}

.logo .site-name,
.logo .dot-net,
nav a.patreon {
  color: white !important;
}\
`

    const addlCssDark = `\
.logo img, .patreon img {
  filter: brightness(0);
}

.logo .site-name,
.logo .dot-net,
nav a.patreon {
  color: black !important;
}\
`

    if (
      this.state.colorData['card-background'] != null &&
      this.state.colorData['card-background'] !== ''
    ) {
      hasWhiteLogo = isDark(this.state.colorData['card-background'])
      hasDarkLogo = !isDark(this.state.colorData['card-background'])
    }

    return (
      <style type="text/css">
        {css}
        {hasWhiteLogo && addlCssLight}
        {hasDarkLogo && addlCssDark}
      </style>
    )
  },
})
