import { define } from './common'

export const definitions = define({
  primary: '#26a69a',
  accent1: '#80cbc4',
  accent2: '#ee6e73',
  text: '#111111',
  textMedium: '#222222',
  textLight: '#333333',
  background: '#FFFFFF',
  cardBackground: '#FFFFFF',
  cardHeaderBackground: '#FFFFFF',
  imageBackground: '#FFFFFF',
  border: '#CCCCCC',
  cardShadow: '#FFFFFF',
})

export const apply = (otherTheme = {}) => {
  const final = {}
  for (const key of Object.keys(definitions)) {
    final[key] = otherTheme[key] || definitions[key][1]
  }
  return final
}

export const base = apply()

export default {
  base,
  apply,
  definitions,
}
