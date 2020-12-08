/* do-not-disable-eslint
    react/jsx-no-undef,
    react/prop-types,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const CharacterLinkCard = function (props) {
  const colorData =
    (props.colorScheme != null ? props.colorScheme.color_data : undefined) || {}

  return (
    <div
      className="character-link-card"
      style={{ backgroundColor: colorData['imageBackground'] || '#000000' }}
    >
      <Link to={props.link} className="image">
        <img src={props.profileImageUrl} />
      </Link>

      <div
        className="details"
        style={{ backgroundColor: colorData['cardBackground'] }}
      >
        <Link
          to={props.link}
          className="name"
          style={{ color: colorData['accent1'] }}
        >
          {props.name}
        </Link>
        <div className="species" style={{ color: colorData['text'] }}>
          {props.species || 'Unknown Species'}
        </div>
      </div>
    </div>
  )
}

export default CharacterLinkCard
