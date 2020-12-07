import routes from '../config/routes'
import qs from 'querystring'

function buildHelpers(object) {
  let obj = { ...object }

  Object.keys(obj).map(key => {
    const match = key.match(/^(\w+)Route$/i)
    if (match) {
      const name = match[1]
      const route = obj[key]

      obj[name + 'Path'] = (params, query) => {
        let path = route.replace(/:(\w+)/g, (match, key) => {
          return params[key]
        })

        if (query) {
          path += '?' + qs.stringify(query)
        }

        return path
      }

      obj[name + 'Url'] = (params, query) => {
        return obj.baseUrl + obj[name + 'Path'](params, query)
      }
    }
  })

  return obj
}

const LinkUtils = buildHelpers(routes)

export default LinkUtils
