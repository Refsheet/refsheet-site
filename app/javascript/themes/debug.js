import { define } from './common'

export const definitions = define({
  primary: '#FF00CC',
  accent1: '#FF00CC',
  accent2: '#FF00CC',
  text: '#FF00CC',
  textMedium: '#FF00CC',
  textLight: '#FF00CC',
  background: '#FF00CC',
  cardBackground: '#FF00CC',
  cardHeaderBackground: '#FF00CC',
  imageBackground: '#FF00CC',
  border: '#FF00CC',
  cardShadow: '#FF00CC',
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
