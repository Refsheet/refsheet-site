import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import removeComment from './removeComment.graphql'
import compose, { withCurrentUser, withMutations } from '../../../utils/compose'
import subscribe from '../../../services/buildSubscriptionRender'
import CommentForm from '../../Shared/CommentForm'
import addComment from './addComment.graphql'
import getComments from './getComments.graphql'
import subscribeToComments from './subscribeToComments.graphql'
import Scrollbars from '../../Shared/Scrollbars'
import { AutoSizer } from 'react-virtualized'
import Moment from 'react-moment'
import EmailConfirmationNag from '../../User/EmailConfirmationNag'

class Comments extends Component {
  constructor(props) {
    super(props)

    this.state = {
      pendingComments: [],
    }
  }

  renderComment(comment) {
    if (!comment.user) {
      comment.user = {
        username: '?',
        avatar_url: '',
        name: '<Deleted User>',
      }
    }

    return (
      <div className="card flat with-avatar" key={comment.id}>
        <img src={comment.user.avatar_url} className="circle avatar" />
        <div className="card-content">
          <Moment fromNow unix withTitle className={'muted right'}>
            {comment.created_at}
          </Moment>
          <Link to={`/${comment.user.username}`}>{comment.user.name}</Link>
          <div className={'comment-content'}>{comment.comment}</div>
        </div>
      </div>
    )
  }

  handleSubmit({ comment, identity }) {
    const { mediaId, addComment } = this.props

    const variables = {
      mediaId,
      comment,
    }

    return addComment({
      variables,
    })
  }

  handlePost({ addComment: comment }) {
    this.setState({
      pendingComments: [...this.state.pendingComments, comment],
    })
  }

  render() {
    const { comments, count = 0, isManaged, loading, currentUser } = this.props

    let renderComments

    if (loading || !comments) {
      renderComments = (
        <p className={'caption padding--medium center'}>Loading...</p>
      )
    } else if (comments.length <= 0) {
      renderComments = (
        <p className={'caption padding--medium center'}>No comments yet!</p>
      )
    } else {
      const pending = this.state.pendingComments.filter(
        c => comments.findIndex(x => x.id === c.id) === -1
      )

      const sorted = [...comments, ...pending].sort(
        (a, b) => b.created_at - a.created_at
      )

      renderComments = sorted.map(this.renderComment)
    }

    return (
      <div className={'flex-vertical comments'}>
        <div className={'flex-content overflow'}>
          <AutoSizer disableWidth>
            {({ height, width }) => (
              <Scrollbars maxHeight={height}>{renderComments}</Scrollbars>
            )}
          </AutoSizer>
        </div>

        {currentUser && (
          <div className="flex-fixed">
            <EmailConfirmationNag slim>
              <CommentForm
                slim
                placeholder={'Add comment...'}
                buttonText={'Send'}
                onSubmit={this.handleSubmit.bind(this)}
                onSubmitConfirm={this.handlePost.bind(this)}
                buttonSubmittingText={'Sending'}
              />
            </EmailConfirmationNag>
          </div>
        )}
      </div>
    )
  }
}

Comments.propTypes = {
  mediaId: PropTypes.string.isRequired,
}

const mapDataToProps = data => ({
  comments: data.getComments && data.getComments.comments,
  page: data.getComments && data.getComments.currentPage,
  totalPages: data.getComments && data.getComments.totalPages,
  commentsLoading: data.loading,
})

const updateQuery = (prev, data) => {
  const { newComment } = data

  return {
    ...prev,
    getComments: {
      ...prev.getComments,
      comments: [...prev.getComments.comments, newComment],
    },
  }
}

export default compose(
  subscribe({
    query: getComments,
    subscription: subscribeToComments,
    mapDataToProps,
    updateQuery,
  }),
  withMutations({ removeComment, addComment }),
  withCurrentUser()
)(Comments)
