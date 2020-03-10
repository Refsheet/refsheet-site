import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Loading from 'v1/shared/Loading'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let LoadingOverlay
export default LoadingOverlay = props => (
  <div className="loading-overlay">
    <Loading />
  </div>
)
