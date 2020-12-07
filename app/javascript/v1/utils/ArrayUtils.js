// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const ArrayUtils = {
  pluck(array, key) {
    return array.map(o => o[key])
  },

  diff(array_1, array_2) {
    return array_1.filter(i => array_2.indexOf(i) < 0)
  },
}

export default ArrayUtils
