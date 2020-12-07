import ObjectPath from 'v1/utils/ObjectPath'
import Model from 'v1/utils/Model'
import $ from 'jquery'
import HashUtils from './HashUtils'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const StateUtils = {
  page(context, path, page, props) {
    if (props == null) {
      ;({ props } = context)
    }
    if (!page) {
      page = (context.currentPage || 1) + 1
    }

    console.debug('[StateUtils] Loading page: ' + page)
    return this.fetch(context, path, { page }, props)
  },

  load(context, path, props, callback, options) {
    let elItem
    if (props == null) {
      ;({ props } = context)
    }
    if (options == null) {
      options = {}
    }
    const { dataPath, paramMap } = context
    const { eagerLoad } = context.context
    const state = $.extend({}, context.state)
    let fetch = true

    console.debug(
      '[StateUtils] Loading with params:',
      props.match != null ? props.match.params : undefined
    )
    console.debug('[StateUtils] Eager Loading:', eagerLoad, context.context)

    if ((elItem = ObjectPath.get(eagerLoad, path))) {
      let match = true
      for (let k in paramMap) {
        const p = paramMap[k]
        const a = ObjectPath.get(
          props.match != null ? props.match.params : undefined,
          k
        )
        const b = ObjectPath.get(elItem, p)
        console.debug('[StateUtils] Comparing:', a, b)
        if (!a || !b || a.toUpperCase() !== b.toUpperCase()) {
          match = false
        }
      }

      if (match) {
        fetch = false
        console.debug('[StateUtils] Eager Loading:', elItem)
        ObjectPath.set(state, path, elItem)
        context.setState(state, function () {
          if (callback) {
            return callback(elItem)
          }
        })
      }
    }

    if (fetch) {
      this.fetch(context, path, options.urlParams, props, callback)
      if (!options.noScroll) {
        console.debug('[StateUtils] Scrolling up!')
        return $(window).scrollTop(0)
      }
    }
  },

  fetch(context, path, data, props, callback) {
    if (data == null) {
      data = {}
    }
    if (props == null) {
      ;({ props } = context)
    }
    const fetchUrl = this.getFetchUrl(context, props)
    const state = $.extend({}, context.state)

    return Model.request(
      'GET',
      fetchUrl,
      data,
      function (data) {
        if (data.$meta) {
          data = ObjectPath.get(data, path)
        }

        ObjectPath.set(state, path, data)
        return context.setState(state, function () {
          if (callback) {
            return callback(data)
          }
        })
      },

      error =>
        context.setState({ error }, function () {
          if (callback) {
            return callback()
          }
        })
    )
  },

  reload(context, path, newProps, oldProps, callback) {
    if (oldProps == null) {
      oldProps = context.props
    }
    let fetch = false

    for (let k in context.paramMap) {
      const p = context.paramMap[k]
      const a = ObjectPath.get(
        oldProps.match != null ? oldProps.match.params : undefined,
        k
      )
      const b = ObjectPath.get(
        newProps.match != null ? newProps.match.params : undefined,
        k
      )

      if (
        (a || b) &&
        (a != null ? a.toUpperCase() : undefined) !==
          (b != null ? b.toUpperCase() : undefined)
      ) {
        fetch = true
        break
      }
    }

    if (fetch) {
      StateUtils.load(context, path, newProps, callback)
      console.debug('[StateUtils] Scrolling up!')
      return $(window).scrollTop(0)
    }
  },

  poll(context, path, props) {
    if (props == null) {
      ;({ props } = context)
    }
  },
  //no-op

  update(context, path, value, callback) {
    return context.setState(HashUtils.set(context.state, path, value), callback)
  },

  updateItem(context, path, item, primaryKey, callback) {
    return context.setState(
      HashUtils.deepUpdateCollectionItem(context.state, path, item, primaryKey),
      callback
    )
  },

  updateItems(context, path, items, primaryKey, callback) {
    let { state } = context

    items.map(
      item =>
        (state = HashUtils.deepUpdateCollectionItem(
          state,
          path,
          item,
          primaryKey
        ))
    )

    return context.setState(state, callback)
  },

  sortItem(context, path, item, position, primaryKey, callback) {
    return context.setState(
      HashUtils.deepSortCollectionItem(
        context.state,
        path,
        item,
        position,
        primaryKey
      ),
      callback
    )
  },

  removeItem(context, path, item, primaryKey, callback) {
    return context.setState(
      HashUtils.deepRemoveCollectionItem(context.state, path, item, primaryKey),
      callback
    )
  },

  getFetchUrl(stateLink, props) {
    if (typeof stateLink === 'function') {
      stateLink = stateLink()
    }
    const { dataPath, paramMap } = stateLink

    const fetchUrl = dataPath.replace(/(:[a-zA-Z]+)/g, function (m) {
      const param = ObjectPath.get(
        props.match != null ? props.match.params : undefined,
        m.substring(1)
      )
      return param || ''
    })

    return fetchUrl.replace(/\/\/+|\/$/g, '')
  },
}

export default StateUtils
