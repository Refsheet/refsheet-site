import { createReducer } from 'reducers'
import * as Actions from 'actions'

const handlers = {
  [Actions.SET_THEME_NAME]: (state, action) => {
    return {
      ...state,
      name: action.name,
    }
  },
  [Actions.SET_THEME_SETTINGS]: (state, action) => {
    const newState = {
      ...state,
      ...action.settings,
    }

    console.log({ newState })
    return newState
  },
}

export default createReducer({}, handlers)
