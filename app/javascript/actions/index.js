export const SET_CURRENT_USER = 'SET_CURRENT_USER'
export function setCurrentUser(user) {
  return {
    type: SET_CURRENT_USER,
    user,
  }
}

export const SET_NSFW_MODE = 'SET_NSFW_MODE'
export function setNsfwMode(nsfwOk = false, confirmed = false) {
  return {
    type: SET_NSFW_MODE,
    confirmed,
    nsfwOk,
  }
}

export const OPEN_CONVERSATION = 'OPEN_CONVERSATION'
export function openConversation(conversationId) {
  return {
    type: OPEN_CONVERSATION,
    conversationId,
  }
}

export const CLOSE_CONVERSATION = 'CLOSE_CONVERSATION'
export function closeConversation(conversationId) {
  return {
    type: CLOSE_CONVERSATION,
    conversationId,
  }
}

export const OPEN_LIGHTBOX = 'OPEN_LIGHTBOX'
export function openLightbox(mediaId, gallery) {
  return {
    type: OPEN_LIGHTBOX,
    mediaId,
    gallery,
  }
}

export const CLOSE_LIGHTBOX = 'CLOSE_LIGHTBOX'
export function closeLightbox() {
  return { type: CLOSE_LIGHTBOX }
}

export const SET_IDENTITY = 'SET_IDENTITY'
export function setIdentity({ user, character }) {
  let identity = null

  if (character) {
    identity = {
      name: character.name,
      avatarUrl: character.profile_image.url.thumbnail,
      characterId: character.id,
    }
  }

  return {
    type: SET_IDENTITY,
    identity,
  }
}

export * from './uploads'
export * from './modals'
export * from './theme'
