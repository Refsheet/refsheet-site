// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS202: Simplify dynamic range loops
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const ObjectPath = {
  get(obj, path) {
    path = path.split('.')
    let parent = obj

    if (path.length > 1) {
      for (
        let i = 0, end = path.length - 2, asc = 0 <= end;
        asc ? i <= end : i >= end;
        asc ? i++ : i--
      ) {
        parent = parent[path[i]]
      }
    }

    return parent != null ? parent[path[path.length - 1]] : undefined
  },

  set(obj, path, value) {
    path = path.split('.')
    let parent = obj

    if (path.length > 1) {
      for (
        let i = 0, end = path.length - 2, asc = 0 <= end;
        asc ? i <= end : i >= end;
        asc ? i++ : i--
      ) {
        parent = parent[path[i]] || (parent[path[i]] = {})
      }
    }

    return (parent[path[path.length - 1]] = value)
  },
}

export default ObjectPath
