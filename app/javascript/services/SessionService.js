import superagent from 'superagent'

const SESSION_PATH = '/session'

const csrf = function() {
  return {
    'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content,
  }
}

const SessionService = {
  login: function(username, password) {
    return superagent
      .post(SESSION_PATH)
      .set(csrf())
      .send({ username, password })
  },

  logout: function() {
    return superagent.delete(SESSION_PATH).set(csrf())
  },

  set: function(params) {
    return superagent
      .put(SESSION_PATH)
      .set(csrf())
      .send(params)
  },
}

export default SessionService
