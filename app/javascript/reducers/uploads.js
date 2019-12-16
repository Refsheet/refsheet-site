import {createReducer} from 'reducers'
import * as Actions from 'actions'

const handlers = {
  [Actions.ENQUEUE_UPLOADS]: (state, action) => (
    {
      ...state,
      files: [
        ...state.files,
        ...action.files
      ],
      selectedIndex: 0,
      modalOpen: true
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
  },

  [Actions.CLEAR_ALL_UPLOADS]: (state, action) => {
    return {
      ...state,
      files: [],
      selectedIndex: null
    }
  },

  [Actions.MODIFY_UPLOAD]: (state, action) => {
    let files = state.files
    let fileIndex = state.files.findIndex((i) => i.id === action.file.id)

    if (fileIndex !== -1) {
      files[fileIndex] = Object.assign(files[fileIndex], action.file)
    }

    console.log({files, fileIndex})

    return {
      ...state,
      files: files
    }
  },

  [Actions.OPEN_UPLOAD_MODAL]: (state, action) => {
    let selectedIndex = state.files.findIndex((file) => file.id === state.uploadId)

    return {
      ...state,
      modalOpen: true,
      selectedIndex,
      characterId: action.characterId
    }
  },

  [Actions.CLOSE_UPLOAD_MODAL]: (state, action) => {
    return {
      ...state,
      modalOpen: false,
      selectedIndex: null,
      characterId: null
    }
  }
}

export default createReducer({}, handlers)
