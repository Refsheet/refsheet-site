definitions = {
  primary: ['Primary Color', '#80cbc4']
  accent1: ['Secondary Color', '#26a69a']
  accent2: ['Accent Color', '#ee6e73']
  text: ['Main Text', 'rgba(255,255,255,0.9)']
  textMedium: ['Muted Text', 'rgba(255,255,255,0.5)']
  textLight: ['Subtle Text', 'rgba(255,255,255,0.3)']
  background: ['Page Background', '#262626']
  cardBackground: ['Card Background', '#212121']
  cardHeaderBackground: ['Card Header Background', 'rgba(0,0,0,0.2)']
  imageBackground: ['Image Background', '#000000']
  border: ['Border Colors', 'rgba(255,255,255,0.1)']
}

apply = (otherTheme={}) ->
  console.log "applying otherTheme", otherTheme
  final = {}
  for k, v of definitions
    console.log {k,v,otk: otherTheme[k]}
    final[k] = otherTheme[k] || v[1]
  final

export default {
  base: apply()
  apply
  definitions
}
