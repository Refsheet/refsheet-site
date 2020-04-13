import { createReducer } from 'reducers'
import * as Actions from 'actions'

function willOpenModal() {
  // Prevent clobbering the lightbox:
  return !document.getElementById('lightbox-v2')
}

const handlers = {
  [Actions.ENQUEUE_UPLOADS]: (state, action) => ({
    ...state,
    files: [...state.files, ...action.files],
    selectedIndex: 0,
    modalOpen: willOpenModal(),
  }),

  [Actions.CLEAR_UPLOAD]: (state, action) => {
    let selectedIndex = state.selectedIndex

    const files = state.files.filter(f => f.id !== action.fileId)

    if (files.length <= selectedIndex) selectedIndex = files.length - 1

    return {
      ...state,
      files: files,
      selectedIndex,
    }
  },

  [Actions.CLEAR_ALL_UPLOADS]: (state, action) => {
    return {
      ...state,
      files: [],
      selectedIndex: null,
    }
  },

  [Actions.MODIFY_UPLOAD]: (state, { file }) => {
    let files = state.files
    let fileIndex = state.files.findIndex(i => i.id === file.id)

    if (fileIndex !== -1) {
      const fields = (({ nsfw, title, hidden }) => ({ nsfw, title, hidden }))(
        file
      )
      files[fileIndex] = Object.assign(files[fileIndex], fields)
    }

    return {
      ...state,
      files: files,
    }
  },

  [Actions.OPEN_UPLOAD_MODAL]: (state, action) => {
    let selectedIndex = state.files.findIndex(
      file => file.id === state.uploadId
    )

    return {
      ...state,
      modalOpen: true,
      selectedIndex,
      characterId: action.characterId || state.characterId,
      uploadCallback: action.uploadCallback || state.uploadCallback,
    }
  },

  [Actions.CLOSE_UPLOAD_MODAL]: (state, action) => {
    return {
      ...state,
      modalOpen: false,
      selectedIndex: null,
    }
  },

  [Actions.SET_UPLOAD_TARGET]: (state, action) => {
    return {
      ...state,
      characterId: action.characterId,
      uploadCallback: action.uploadCallback,
    }
  },

  [Actions.DISABLE_DROPZONE]: state => {
    return {
      ...state,
      dropzoneDisabled: true,
    }
  },

  [Actions.ENABLE_DROPZONE]: state => {
    return {
      ...state,
      dropzoneDisabled: false,
    }
  },
}

export default createReducer({}, handlers)
