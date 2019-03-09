import { createReducer } from 'reducers'
import * as Actions from 'actions'

const handlers = {
  [Actions.ENQUEUE_UPLOADS]: (state, action) => (
    {
      ...state,
      files: [
        ...state.files,
        ...action.files
      ],
      selectedIndex: 0
    }
  ),

  [Actions.CLEAR_UPLOAD]: (state, action) => {
    let selectedIndex = state.selectedIndex

    const files = state.files
      .filter(f => f.id !== action.fileId)

    if (files.length <= selectedIndex)
      selectedIndex = files.length - 1

    return {
      ...state,
      files: files,
      selectedIndex
    }
  }
}

export default createReducer({}, handlers)
