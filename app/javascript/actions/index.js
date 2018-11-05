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
