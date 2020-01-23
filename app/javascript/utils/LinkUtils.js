import routes from '../config/routes'

function buildHelpers(object) {
  let obj = { ...object }

  Object.keys(obj).map(key => {
    const match = key.match(/^(\w+)Route$/i)
    if (match) {
      const name = match[1]
      const route = obj[key]

      obj[name + 'Path'] = params => {
        console.log({ params })
        return route.replace(/:(\w+)/g, (match, key) => {
          return params[key]
        })
      }

      obj[name + 'Url'] = params => {
        return obj.baseUrl + obj[name + 'Path'](params)
      }
    }
  })

  console.log({ obj })
  return obj
}

const LinkUtils = buildHelpers(routes)

export default LinkUtils
