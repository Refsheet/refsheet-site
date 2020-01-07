import Color from 'color'

class ColorTheme {
  constructor({primary: accent, text, background}) {
    this.accent = Color(accent)
    this.text = Color(text)
    this.background = Color(background)

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

  isLight() {
    return this.background.isLight()
  }

  isDark() {
    return this.background.isDark()
  }

  makeLight() {
    this.text = Color(this.simpleBase.light.text)
    this.background = Color(this.simpleBase.light.background)
  }

  makeDark() {
    this.text = Color(this.simpleBase.dark.text)
    this.background = Color(this.simpleBase.dark.background)
  }


  // Generators for Simple Themes

  genAccent1() {
    return this.accent.rotate(180)
  }

  genAccent2() {
    return this.accent.rotate(-90)
  }

  genTextLight() {
    return this.isLight() ? this.text.lighten(0.5) : this.text.darken(0.5)
  }

  genTextMedium() {
    return this.isLight() ? this.text.lighten(1) : this.text.darken(1)
  }

  genCardBackground() {
    return this.isLight() ? this.background.lighten(0.1) : this.background.darken(0.1)
  }

  genImageBackground() {
    return this.isLight() ? this.background.lighten(1) : this.background.darken(1)
  }


  // Export Options

  getHash() {
    return {
      primary: this.accent.hex().string(),
      accent1: this.genAccent1().hex().string(),
      accent2: this.genAccent2().hex().string(),

      text: this.text.hex().string(),
      textLight: this.genTextLight().string(),
      textMedium: this.genTextMedium().string(),

      background: this.background.hex().string(),
      cardBackground: this.genCardBackground().hex().string(),
      imageBackground: this.genImageBackground().hex().string(),
    }
  }
}

export default ColorTheme