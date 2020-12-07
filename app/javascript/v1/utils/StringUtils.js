// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class StringUtils {
  static camelize(string) {
    //
    // by http://stackoverflow.com/users/140811/scott
    // at http://stackoverflow.com/a/2970588/6776673

    return string
      .toLowerCase()
      .replace(/_(.)/g, $1 => $1.toUpperCase())
      .replace(/_/g, '')
  }

  static camelizeKeys(object) {
    const out = {}

    for (let k in object) {
      const v = object[k]
      out[this.camelize(k)] = v
    }

    return out
  }

  static unCamelize(string) {
    return string.replace(
      /([a-z])([A-Z])/g,
      (a, $0, $1) => $0 + '_' + $1.toLowerCase()
    )
  }

  static unCamelizeKeys(object) {
    const out = {}

    for (let k in object) {
      const v = object[k]
      out[this.unCamelize(k)] = v
    }

    return out
  }

  static indifferentKeys(object) {
    const out = {}

    for (let k in object) {
      const v = object[k]
      out[k] = v
      out[this.camelize(k)] = v
    }

    return out
  }
}
export default StringUtils
