import { createReducer } from 'reducers'
import * as Actions from 'actions'
import SessionService from '../services/SessionService'

const handlers = {
  [Actions.SET_CURRENT_USER]: (state, action) => (
      {...state, currentUser: action.user}
  ),
  [Actions.SET_NSFW_MODE]: (state, action) => {
    // TODO FIXME HACK: This should use a styled modal and not a browser confirm. Also, it shouldn't do a server call, but hey whatever.
    if (action.nsfwOk && !confirm("By continuing, you assert that you are 18 years or older, and that it is legal for you to view explicit content.")) {
      return state
    } else {
      SessionService.set({nsfwOk: action.nsfwOk}).then()
    }
    return {...state, nsfwOk: action.nsfwOk}
  }
}

export default createReducer({}, handlers)
