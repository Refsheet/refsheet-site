/* do-not-disable-eslint
    no-undef,
    react/display-name,
    react/jsx-no-undef,
    react/prop-types,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Card from './_card'
import Column from 'v1/shared/material/Column'
import Row from 'v1/shared/material/Row'
import StringUtils from '../../../utils/StringUtils'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const Table = function (props) {
  const { forums, title } = props

  const forumCards = forums.map((forum) => (
    <Column l={4} xl={3} key={forum.slug}>
      <Card {...StringUtils.camelizeKeys(forum)} />
    </Column>
  ))

  return (
    <div className="collection-group">
      <h3 className="group-title margin-top--none">{title}</h3>

      <Row>{forumCards}</Row>
    </div>
  )
}

export default Table
