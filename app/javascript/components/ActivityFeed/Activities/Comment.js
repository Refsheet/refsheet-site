/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'
import GalleryImage from 'v1/shared/images/GalleryImage'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Comment
export default Comment = createReactClass({
  propTypes: {
    comments: PropTypes.array.isRequired,
  },

  render() {
    const comments = this.props.comments.map(comment => {
      return (
        <Row key={comment.id} noMargin className="padding-top--small">
          <Column s={6} m={4}>
            <GalleryImage image={comment.media} size="small" />
          </Column>
          <Column s={12} m={8}>
            <div className="chat-bubble receive turn-up-for-what margin-right--rlarge">
              {comment.comment}
            </div>
          </Column>
        </Row>
      )
    })

    return <div className="activity shift-up">{comments}</div>
  },
})
