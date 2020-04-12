export const ENQUEUE_UPLOADS = 'ENQUEUE_UPLOADS'
export function enqueueUploads(files) {
  return {
    type: ENQUEUE_UPLOADS,
    files,
  }
}

export const CLEAR_UPLOAD = 'CLEAR_UPLOAD'
export function clearUpload(fileId) {
  return {
    type: CLEAR_UPLOAD,
    fileId,
  }
}

export const CLEAR_ALL_UPLOADS = 'CLEAR_ALL_UPLOADS'
export function clearAllUploads() {
  return {
    type: CLEAR_ALL_UPLOADS,
  }
}

export const MODIFY_UPLOAD = 'MODIFY_UPLOAD'
export function modifyUpload(file) {
  return {
    type: MODIFY_UPLOAD,
    file,
  }
}

export const OPEN_UPLOAD_MODAL = 'OPEN_UPLOAD_MODAL'
export function openUploadModal(uploadId, characterId, uploadCallback = null) {
  return {
    type: OPEN_UPLOAD_MODAL,
    uploadId,
    characterId,
    uploadCallback,
  }
}

export const CLOSE_UPLOAD_MODAL = 'CLOSE_UPLOAD_MODAL'
export function closeUploadModal() {
  return {
    type: CLOSE_UPLOAD_MODAL,
  }
}

export const SET_UPLOAD_TARGET = 'SET_UPLOAD_TARGET'
export function setUploadTarget(characterId, uploadCallback = null) {
  return {
    type: SET_UPLOAD_TARGET,
    characterId,
    uploadCallback,
  }
}

export const DISABLE_DROPZONE = 'DISABLE_DROPZONE'
export function disableDropzone() {
  return {
    type: DISABLE_DROPZONE,
  }
}

export const ENABLE_DROPZONE = 'ENABLE_DROPZONE'
export function enableDropzone() {
  return {
    type: ENABLE_DROPZONE,
  }
}
