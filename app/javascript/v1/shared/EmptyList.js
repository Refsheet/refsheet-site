import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Icon from 'v1/shared/material/Icon'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let EmptyList
export default EmptyList = function (props) {
  const { coffee, caption } = props

  return (
    <div className="empty-list">
      {coffee && <Icon className="other">local_cafe</Icon>}

      {!coffee && <Icon className="sun">wb_sunny</Icon>}

      {!coffee && <Icon className="cloud">cloud</Icon>}

      <p>{caption || 'Nothing to see here!'}</p>
    </div>
  )
}
