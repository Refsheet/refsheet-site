export const SET_THEME_NAME = 'SET_THEME_NAME'
export function setThemeName(name) {
  return {
    type: SET_THEME_NAME,
    name,
  }
}

export const SET_THEME_SETTINGS = 'SET_THEME_SETTINGS'
export function setThemeSettings(settings) {
  return {
    type: SET_THEME_SETTINGS,
    settings,
  }
}
