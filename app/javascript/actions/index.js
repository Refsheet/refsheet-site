export const SET_CURRENT_USER = 'SET_CURRENT_USER'
export function setCurrentUser(user) {
  return {
    type: SET_CURRENT_USER,
    user
  }
}

export const SET_NSFW_MODE = 'SET_NSFW_MODE'
export function setNsfwMode(nsfwOk=false) {
  return {
    type: SET_NSFW_MODE,
    nsfwOk
  }
}

export const OPEN_CONVERSATION = 'OPEN_CONVERSATION'
export function openConversation(conversationId) {
  return {
    type: OPEN_CONVERSATION,
    conversationId
  }
}

export const CLOSE_CONVERSATION = 'CLOSE_CONVERSATION'
export function closeConversation(conversationId) {
  return {
    type: CLOSE_CONVERSATION,
    conversationId
  }
}

export const ENQUEUE_UPLOADS = 'ENQUEUE_UPLOADS'
export function enqueueUploads(files) {
  return {
    type: ENQUEUE_UPLOADS,
    files
  }
}

export const CLEAR_UPLOAD = 'CLEAR_UPLOAD'
export function clearUpload(fileId) {
  return {
    type: CLEAR_UPLOAD,
    fileId
  }
}

export const MODIFY_UPLOAD = 'MODIFY_UPLOAD'
export function modifyUpload(file) {
  return {
    type: MODIFY_UPLOAD,
    file
  }
}

export const OPEN_LIGHTBOX = 'OPEN_LIGHTBOX'
export function openLightbox(mediaId, gallery) {
  return {
    type: OPEN_LIGHTBOX,
    mediaId,
    gallery
  }
}

export const CLOSE_LIGHTBOX = 'CLOSE_LIGHTBOX'
export function closeLightbox() {
  return { type: CLOSE_LIGHTBOX }
}