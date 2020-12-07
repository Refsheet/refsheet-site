import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let SwatchRule
export default SwatchRule = function (props) {
  const swatches = props.swatches.map(swatch => (
    <div
      className="swatch"
      key={swatch.id}
      style={{ backgroundColor: swatch.color }}
    />
  ))

  return (
    <section className="character-swatches">
      <div className="container">
        <div className="swatch-container z-depth-1">
          <div className="swatch-row">{swatches}</div>
        </div>
      </div>
    </section>
  )
}
