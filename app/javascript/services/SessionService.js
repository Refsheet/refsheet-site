import superagent from 'superagent'
import { csrf } from './ApplicationService'

const SESSION_PATH = '/session'

const SessionService = {
  login: function (username, password) {
    return superagent
      .post(SESSION_PATH)
      .set(csrf())
      .send({ username, password })
  },

  logout: function () {
    return superagent.delete(SESSION_PATH).set(csrf())
  },

  set: function (params) {
    return superagent.put(SESSION_PATH).set(csrf()).send(params)
  },
}

export default SessionService
