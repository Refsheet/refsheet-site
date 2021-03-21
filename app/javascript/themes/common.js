export const definitionNames = {
  primary: 'Primary Color',
  accent1: 'Secondary Color',
  accent2: 'Accent Color',
  text: 'Main Text',
  textMedium: 'Muted Text',
  textLight: 'Subtle Text',
  background: 'Page Background',
  cardBackground: 'Card Background',
  cardHeaderBackground: 'Card Header Background',
  imageBackground: 'Image Background',
  border: 'Border Colors',
  cardShadow: 'Card Shadow Color',
}

export const define = defs => {
  const final = {}
  for (const key of Object.keys(defs)) {
    final[key] = [definitionNames[key], defs[key]]
  }
  return final
}
