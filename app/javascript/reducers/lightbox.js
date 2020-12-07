import { createReducer } from 'reducers'
import * as Actions from 'actions'

const handlers = {
  [Actions.OPEN_LIGHTBOX]: (state, action) => {
    let gallery = []

    if (action.gallery) {
      gallery = action.gallery
    }

    return {
      ...state,
      mediaId: action.mediaId,
      gallery,
    }
  },
  [Actions.CLOSE_LIGHTBOX]: state => ({ ...state, mediaId: null }),
}

export default createReducer({}, handlers)
