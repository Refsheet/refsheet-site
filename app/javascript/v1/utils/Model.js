/* do-not-disable-eslint
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import * as Materialize from 'materialize-css'
import $ from 'jquery'

const Model = {
  get(path, success, error) {
    return this.request('GET', path, {}, success, error)
  },

  post(path, data, success, error) {
    return this.request('POST', path, data, success, error)
  },

  put(path, data, success, error) {
    return this.request('PUT', path, data, success, error)
  },

  delete(path, success, error) {
    return this.request('DELETE', path, {}, success, error)
  },

  poll(path, data, success) {
    if (window.location.hash === '#nopoll') {
      return
    }
    console.debug(`POLL ${path}`, data)

    return $.ajax({
      url: path,
      type: 'GET',
      data,
      dataType: 'json',
      success,
    })
  },

  request(type, path, data, success, error) {
    console.debug(`${type} ${path}`, data)

    return $.ajax({
      url: path,
      type,
      data,
      dataType: 'json',
      success,

      error: e => {
        const msg = e.responseJSON || e.responseText || 'Unknown error.'
        console.warn(`Error sending request: ${JSON.stringify(msg)}`, e)

        if (error) {
          return error(msg)
        } else {
          if (msg && msg.error) {
            return Materialize.toast({
              html: msg.error,
              displayLength: 3000,
              classes: 'red',
            })
          }
        }
      },
    })
  },
}

export default Model
