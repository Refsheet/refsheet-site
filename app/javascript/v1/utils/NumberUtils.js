// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const NumberUtils = {
  format(i) {
    const n = Math.abs(i)
    switch (false) {
      case !(n < 1e3):
        return n + ''
      case !(n < 1e4):
        return Math.floor(n / 1e2) / 10 + 'k'
      case !(n < 1e6):
        return Math.floor(n / 1e3) + 'k'
      case !(n < 1e7):
        return Math.floor(n / 1e5) / 10 + 'm'
      default:
        return Math.floor(n / 1e6) + 'm'
    }
  },
}

export default NumberUtils
