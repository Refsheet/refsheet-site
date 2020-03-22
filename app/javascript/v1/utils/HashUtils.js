/* do-not-disable-eslint
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import ObjectPath from './ObjectPath'
import $ from 'jquery'

const HashUtils = {
  deepUpdateCollectionItem(object, collectionPath, item, primaryKey) {
    const collection = ObjectPath.get(object, collectionPath)
    if (!collection) {
      return
    }
    const [old, index] = Array.from(this.findItem(collection, item, primaryKey))

    if (old) {
      collection[index] = item
    } else {
      collection.push(item)
    }

    return this.set(object, collectionPath, collection)
  },

  deepSortCollectionItem(object, collectionPath, item, position, primaryKey) {
    const collection = ObjectPath.get(object, collectionPath)
    if (!collection) {
      return
    }
    const [old, index] = Array.from(this.findItem(collection, item, primaryKey))

    if (old) {
      collection.splice(index, 1)
      collection.splice(position, 0, old)
    }

    return this.set(object, collectionPath, collection)
  },

  deepRemoveCollectionItem(object, collectionPath, item, primaryKey) {
    const collection = ObjectPath.get(object, collectionPath)
    if (!collection) {
      return
    }
    const [old, index] = Array.from(this.findItem(collection, item, primaryKey))

    if (old) {
      collection.splice(index, 1)
    }

    return this.set(object, collectionPath, collection)
  },

  // An immutable variant of ObjectPath.set that saves the original object
  //
  set(object, path, value) {
    object = $.extend({}, object)
    ObjectPath.set(object, path, value)
    return object
  },

  itemExists(collection, item, primaryKey) {
    if (primaryKey == null) {
      primaryKey = 'id'
    }
    if (!collection || !item) {
      return
    }
    const targetKey = typeof item === 'object' ? item[primaryKey] : item
    return !!collection.filter(
      i => (i != null ? i[primaryKey] : undefined) === targetKey
    )[0]
  },

  findItem(collection, item, primaryKey, callback) {
    let index
    if (primaryKey == null) {
      primaryKey = 'id'
    }
    if (!collection || !item) {
      return []
    }
    const targetKey = typeof item === 'object' ? item[primaryKey] : item
    const old = collection.filter(
      i => (i != null ? i[primaryKey] : undefined) === targetKey
    )[0]
    if (old) {
      index = collection.indexOf(old)
    }
    if (callback) {
      callback(old, index)
    }
    return [old, index]
  },

  compare(a, b, ...keys) {
    for (let k of Array.from(keys)) {
      const ca = ObjectPath.get(a, k)
      const cb = ObjectPath.get(b, k)
      if (ca !== cb) {
        return false
      }
    }
    return true
  },

  groupBy(items, path) {
    const final = {}

    if (!items) {
      return final
    }

    for (let item of Array.from(items)) {
      const key = ObjectPath.get(item, path)
      if (!final[key]) {
        final[key] = []
      }
      final[key].push(item)
    }

    return final
  },
}

export default HashUtils
