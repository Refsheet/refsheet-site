import { createReducer } from 'reducers'
import * as Actions from 'actions'

const handlers = {
  [Actions.SET_CURRENT_USER]: (state, action) => (
      {...state, currentUser: action.user}
  ),
  [Actions.SET_NSFW_MODE]: (state, action) => (
      {...state, nsfwOk: action.nsfwOk}
  )
}

export default createReducer({}, handlers)
