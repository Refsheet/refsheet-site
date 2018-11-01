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
