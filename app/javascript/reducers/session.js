import merge from 'lodash/merge'
import * as Actions from 'actions'

export default function session(state={}, action) {
  console.log({action})

  switch(action.type) {
    case Actions.SET_CURRENT_USER:
      return merge({}, state, {currentUser: action.user})
    default:
      console.warn("Session reducer handled unknown action:", action.type)
      return state
  }
}
