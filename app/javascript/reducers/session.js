import { createReducer } from 'reducers'
import * as Actions from 'actions'
import SessionService from '../services/SessionService'

const identityFromUser = user => {
  if (!user) return null
  return {
    name: user.name,
    avatarUrl: user.avatar_url,
    characterId: null,
  }
}

const handlers = {
  [Actions.SET_CURRENT_USER]: (state, action) => ({
    ...state,
    currentUser: action.user,
    identity: identityFromUser(action.user),
  }),
  [Actions.SET_NSFW_MODE]: (state, action) => {
    // TODO FIXME HACK: This should use a styled modal and not a browser confirm. Also, it shouldn't do a server call, but hey whatever.
    if (
      action.nsfwOk &&
      !action.confirmed &&
      !confirm(
        'By continuing, you assert that you are 18 years or older, and that it is legal for you to view explicit content.'
      )
    ) {
      return state
    }

    SessionService.set({ nsfwOk: action.nsfwOk }).then()
    return { ...state, nsfwOk: action.nsfwOk }
  },
  [Actions.SET_IDENTITY]: (state, action) => {
    let identity

    if (action.identity) {
      identity = action.identity
    } else {
      identity = identityFromUser(state.currentUser)
    }

    return {
      ...state,
      identity,
    }
  },
}

export default createReducer({}, handlers)
