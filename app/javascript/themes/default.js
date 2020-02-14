export const definitions = {
  primary: ['Primary Color', '#26a69a'],
  accent1: ['Secondary Color', '#80cbc4'],
  accent2: ['Accent Color', '#ee6e73'],
  text: ['Main Text', 'rgba(255,255,255,0.9)'],
  textMedium: ['Muted Text', 'rgba(255,255,255,0.5)'],
  textLight: ['Subtle Text', 'rgba(255,255,255,0.3)'],
  background: ['Page Background', '#262626'],
  cardBackground: ['Card Background', '#212121'],
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
