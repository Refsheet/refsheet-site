// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import Axios from 'axios'
import { CancelToken } from 'axios'

export var get = function ({ path, request }) {
  const source = CancelToken.source()
  console.log(`GET ${path}`)

  return new Promise(function (resolve, reject) {
    Axios.get(path, { cancelToken: source.token })
      .then(req => {
        const { data } = req
        return resolve(data)
      })
      .catch(req => {
        const { data } = req
        const error = (data != null ? data.error : undefined) || req.statusText
        console.error(error, data, req)
        return reject({ error })
      })

    if (request) {
      return request(source)
    }
  })
}

export var put = function ({ path, params, request }) {
  const source = CancelToken.source()
  console.log(`PUT ${path}: ${JSON.stringify(params)}`)

  return new Promise(function (resolve, reject) {
    Axios.put(path, params, { cancelToken: source.token })
      .then(req => {
        const { data } = req
        return resolve(data)
      })
      .catch(req => {
        const { data } = req
        const error = (data != null ? data.error : undefined) || req.statusText
        console.error(error, data, req)
        return reject({ error })
      })

    if (request) {
      return request(source)
    }
  })
}
