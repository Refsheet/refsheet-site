/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/prop-types,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Feed from './_feed'
import Layout from '../layout'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Show extends React.Component {
  render() {
    return (
      <Layout {...this.props}>
        <Feed filter={this.props.location.query.feed} />
      </Layout>
    )
  }
}

export default Show
