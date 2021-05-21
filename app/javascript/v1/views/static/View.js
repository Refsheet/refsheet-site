/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/prop-types,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'
import Main from '../../shared/Main'
import StateUtils from '../../utils/StateUtils'
import { sanitize } from '../../../utils/sanitize'

let View
export default View = createReactClass({
  contextTypes: {
    eagerLoad: PropTypes.object,
  },

  dataPath: '/static/:pageId',

  paramMap: {
    pageId: 'id',
  },

  getInitialState() {
    return {
      page: null,
      error: null,
    }
  },

  componentDidMount() {
    const props = {
      match: {
        params: {
          pageId:
            (this.props.match != null
              ? this.props.match.params.pageId
              : undefined) || this.props.location.pathname.replace(/^\//, ''),
        },
      },
    }
    return StateUtils.load(this, 'page', props)
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (
      (newProps.location.pathname &&
        newProps.location.pathname === this.props.location.pathname) ||
      ((newProps.match != null ? newProps.match.params.pageId : undefined) &&
        (newProps.match != null ? newProps.match.params.pageId : undefined) ===
          (this.props.match != null
            ? this.props.match.params.pageId
            : undefined))
    ) {
      return
    }
    const props = {
      match: {
        params: {
          pageId:
            (newProps.match != null
              ? newProps.match.params.pageId
              : undefined) || newProps.location.pathname.replace(/^\//, ''),
        },
      },
    }
    return StateUtils.reload(this, 'page', props, {
      params: {
        pageId: this.state.page != null ? this.state.page.id : undefined,
      },
    })
  },

  //== Render

  render() {
    if (this.state.page) {
      return (
        <Main title={this.state.page.title}>
          <div
            dangerouslySetInnerHTML={{
              __html: sanitize(this.state.page.content),
            }}
          />
        </Main>
      )
    } else {
      return <Main />
    }
  },
})
