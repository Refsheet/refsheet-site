/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
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
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ForumDiscussion
export default ForumDiscussion = createReactClass({
  propTypes: {
    discussions: PropTypes.array.isRequired,
  },

  render() {
    const discussions = this.props.discussions.map(discussion => {
      return (
        <div
          key={discussion.id}
          className="card-panel z-depth-0 margin-bottom--none margin-top--small"
          style={{ backgroundColor: '#1a1a1a', padding: '1rem' }}
        >
          <div className="muted right">
            <Link to={'/forums/' + discussion.forum.id}>
              {discussion.forum.name}
            </Link>
          </div>
          <h3 className="margin-top--none margin-bottom--medium">
            <Link to={discussion.path}>{discussion.topic}</Link>
          </h3>
          {discussion.content_text.substr(0, 120)}
        </div>
      )
    })

    return <div className="activity shift-up">{discussions}</div>
  },
})
