import React from 'react'
import qs from 'querystring'
import { withRouter } from 'react-router'

/**
 * Like +withRouter+ but adds a `query` param.
 */
function withQuery(Component) {
  const Wrapped = props => {
    const search = (props.history.location.search || '?').replace(/^\?/, '')
    const query = qs.parse(search)
    return React.createElement(Component, { ...props, query })
  }

  Wrapped.displayName = `withQuery(${
    Component.displayName || Component.name || 'Component'
  })`

  return withRouter(Wrapped)
}

export { withQuery }
