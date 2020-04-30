import Color from 'color'

class ColorTheme {
  constructor({ primary: accent, text, background, base: mode }) {
    this.accent = Color(accent)
    this.text = Color(text)
    this.background = Color(background)
    this.mode = mode || (this.background.isLight() ? 'light' : 'dark')

    this.simpleBase = {
      dark: {
        brand: '#80CBC4',
        text: '#bdbdbd',
        background: '#262626',
      },
      light: {
        brand: '#00897b',
        text: '#212121',
        background: '#eeeeee',
      },
    }
  }

  isLight() {
    return this.mode === 'light'
  }

  isDark() {
    return !this.isLight()
  }

  makeLight() {
    this.mode = 'light'
    this.text = Color(this.simpleBase.light.text)
    this.background = Color(this.simpleBase.light.background)
  }

  makeDark() {
    this.mode = 'dark'
    this.text = Color(this.simpleBase.dark.text)
    this.background = Color(this.simpleBase.dark.background)
  }

  // Generators for Simple Themes

  quiet(color, amount, lighten = amount) {
    return this.isLight() ? color.lighten(lighten) : color.darken(amount)
  }

  loud(color, amount, lighten = amount) {
    return this.isDark() ? color.lighten(lighten) : color.darken(amount)
  }

  genAccent1() {
    return this.quiet(this.accent.rotate(30).desaturate(0.2), 0.1)
  }

  genAccent2() {
    return this.quiet(this.accent.rotate(30).desaturate(0.3), 0.2)
  }

  genTextLight() {
    return this.quiet(this.text, 0.35)
  }

  genTextMedium() {
    return this.quiet(this.text, 0.1)
  }

  genCardBackground() {
    return this.quiet(this.background, 0.1)
  }

  genImageBackground() {
    return this.quiet(this.background, 0.6)
  }

  // Export Options

  getHash() {
    return {
      primary: this.accent.hex(),
      accent1: this.genAccent1().hex(),
      accent2: this.genAccent2().hex(),

      text: this.text.hex(),
      textLight: this.genTextLight().hex(),
      textMedium: this.genTextMedium().hex(),

      background: this.background.hex(),
      cardBackground: this.genCardBackground().hex(),
      imageBackground: this.genImageBackground().hex(),
    }
  }

  getSuggestions({
    base = 'accent',
    highContrast = false,
    includeBase = false,
    desaturate = 0,
    darken = 0,
    lighten = 0,
    count = 10,
  }) {
    let suggestions = []
    let baseColor

    if (base !== 'accent') {
      baseColor = Color(this.simpleBase[this.mode][base])
    } else {
      baseColor = this.accent
    }

    if (includeBase === true) {
      suggestions.push(baseColor)
    } else if (includeBase) {
      suggestions.push(Color(this.simpleBase[this.mode][includeBase]))
    }

    for (let i = 0; i < 360; i += 360 / count) {
      let color = baseColor.rotate(i).desaturate(desaturate)

      if (this.isLight() ^ highContrast) {
        suggestions.push(color.lighten(lighten))
      } else {
        suggestions.push(color.darken(darken))
      }
    }

    return suggestions.map(s => s.hex())
  }
}

export default ColorTheme
