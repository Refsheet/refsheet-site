/**
 * Various string manipulation functions, mostly for handling camelization/unCamelization of object keys.
 *
 * @example
 *    StringUtils.camelize("i_am_snek") // => "iAmSnek"
 *    StringUtils.camelizeKeys({ foo_bar: "baz"}) // => { fooBar: "baz" }
 */
class StringUtils {
  /**
   * Camelize a string.
   * @param string {string} - i_am_a_string
   * @returns {string} - iAmAString
   */
  static camelize(string) {
    return string.replace(
      /(([a-z0-9])_(.))/g,
      ($0, $1, $2, $3) => $2 + $3.toUpperCase()
    )
  }

  /**
   * Camelize object keys. This is not recursive, only the top level will be camelized.
   * @param object {object} - { i_am: "an object" }
   * @returns {object} - { iAm: "an object" }
   */
  static camelizeKeys(object) {
    const out = {}

    for (let k in object) {
      const v = object[k]
      out[this.camelize(k)] = v
    }

    return out
  }

  /**
   * Un-camelize a string.
   * @param string {string} - iAmAString
   * @returns {string} - i_am_a_string
   */
  static unCamelize(string) {
    return string.replace(
      /([a-z])([A-Z])/g,
      (a, $0, $1) => $0 + '_' + $1.toLowerCase()
    )
  }

  /**
   * Humanize a string.
   * @param string {string} - iAmAString
   * @returns {string} - I Am A String
   */
  static humanize(string) {
    const uncamel = this.unCamelize(string)
    return uncamel.replace(/(^([a-z0-9])|[_.]([a-z0-9]))/gi, (a, $0, $1, $2) =>
      ($1 || ' ' + $2).toUpperCase()
    )
  }

  /**
   * Un-camelize an object. This is also not recursive.
   * @param object {object} - { iAm: "an object" }
   * @returns {object} - { i_am: "an object" }
   */
  static unCamelizeKeys(object) {
    const out = {}

    for (let k in object) {
      const v = object[k]
      out[this.unCamelize(k)] = v
    }

    return out
  }

  /**
   * Camelize an object, but leave the snake case strings as well. This is more of a lazy hack than a real solution,
   * and should likely be avoided. Please. Thank you.
   * @param object {object} - { i_am: "an object" }
   * @returns {object} - { i_am: "an object", iAm: "an object" }
   */
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
