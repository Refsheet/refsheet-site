export const definitions = {
  primary: ['Primary Color', '#660066'],
  accent1: ['Secondary Color', '#006666'],
  accent2: ['Accent Color', '#666600'],
  text: ['Main Text', '#330033'],
  textMedium: ['Muted Text', '#003333'],
  textLight: ['Subtle Text', '#333300'],
  background: ['Page Background', '#FFFF99'],
  cardBackground: ['Card Background', '#FFFFCC'],
  cardHeaderBackground: ['Card Header Background', '#FFCCCC'],
  imageBackground: ['Image Background', '#00FF00'],
  border: ['Border Colors', '#009900'],
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
