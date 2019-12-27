import { combineReducers } from 'redux'
import session from './session'
import conversations from './conversations'
import uploads from './uploads'
import lightbox from './lightbox'

export function createReducer(initialState, handlers) {
  return function reducer(state = initialState, action) {
    if (handlers.hasOwnProperty(action.type)) {
      console.log({ action })
      return handlers[action.type](state, action)
    } else {
      return state
    }
  }
}

export default combineReducers({
  session,
  conversations,
  uploads,
  lightbox,
})
