export const definitions = {
  primary: ['Primary Color', '#26a69a'],
  accent1: ['Secondary Color', '#80cbc4'],
  accent2: ['Accent Color', '#ee6e73'],
  text: ['Main Text', '#EEEEEE'],
  textMedium: ['Muted Text', '#CCCCCC'],
  textLight: ['Subtle Text', '#AAAAAA'],
  background: ['Page Background', '#000000'],
  cardBackground: ['Card Background', '#000000'],
  cardHeaderBackground: ['Card Header Background', 'rgba(0,0,0,0.2)'],
  imageBackground: ['Image Background', '#000000'],
  border: ['Border Colors', 'rgba(255,255,255,0.1)'],
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
