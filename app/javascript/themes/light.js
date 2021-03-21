export const definitions = {
  primary: ['Primary Color', '#80CBC4'],
  accent1: ['Secondary Color', '#9EBBCF'],
  accent2: ['Accent Color', '#B6CAD7'],
  text: ['Main Text', '#323232'],
  textMedium: ['Muted Text', '#373737'],
  textLight: ['Subtle Text', '#444444'],
  background: ['Page Background', '#EEEEEE'],
  cardBackground: ['Card Background', '#FFFFFF'],
  cardHeaderBackground: ['Card Header Background', 'rgba(0,0,0,0.05)'],
  imageBackground: ['Image Background', '#FFFFFF'],
  border: ['Border Colors', 'rgba(0,0,0,0.1)'],
}

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
