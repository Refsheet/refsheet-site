import StringUtils from './StringUtils'

export var changes = function (a, b) {
  const changedData = {}
  for (let k in b) {
    const v = b[k]
    if (a[k] !== v) {
      changedData[k] = v
    }
  }
  return changedData
}

export var camelize = function (obj) {
  if (!obj || typeof obj !== 'object') {
    return obj
  }
  const out = {}
  for (let k in obj) {
    const v = obj[k]
    out[StringUtils.camelize(k)] = camelize(v)
  }
  return out
}

export function deepRemoveKeys(object, key) {
  if (!object || typeof object !== 'object') {
    return object
  }

  let obj = { ...object }
  delete obj[key]
  Object.keys(obj).map(k => (obj[k] = deepRemoveKeys(obj[k], key)))
  return obj
}

export function flatten(object, path = '') {
  /**
   * @param object - { foo: { bar: "Baz" } }
   * @return { "foo.bar" : "Baz" }
   */

  if (!object || typeof object !== 'object') {
    return object
  }

  let out = {}

  Object.keys(object).map(k => {
    const currentPath = [path, k].filter(p => !!p).join('.')
    const child = object[k]

    if (!child || typeof child !== 'object') {
      out[currentPath] = child
    } else {
      out = { ...out, ...flatten(object[k], currentPath) }
    }
  })

  return out
}
