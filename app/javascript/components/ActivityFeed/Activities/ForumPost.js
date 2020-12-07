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
let ForumPost
export default ForumPost = createReactClass({
  propTypes: {
    posts: PropTypes.array.isRequired,
    action: PropTypes.string,
  },

  render() {
    let str
    if (this.props.posts.length === 1) {
      str = 'a discussion'
    } else {
      str = `${this.props.posts.length} discussions`
    }

    const action = this.props.action || 'Replied to'

    const posts = this.props.posts.map(post => {
      return (
        <div
          key={post.id}
          className="card-panel z-depth-0"
          style={{ backgroundColor: '#1a1a1a', padding: '1rem' }}
        >
          <div className="muted right">
            <Link to={'/forums/' + post.forum.id}>{post.forum.name}</Link>
          </div>

          <h3 className="margin-top--none margin-bottom--medium">
            <Link to={post.path || ''}>RE: {post.thread.topic}</Link>
          </h3>
          {post.content_text.substr(0, 120)}
        </div>
      )
    })

    return (
      <div className="activity padding-bottom--small">
        <div className="headline margin-bottom--medium">
          {action} {str}:
        </div>

        {posts}
      </div>
    )
  },
})
