import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser } from '../../../utils/compose'
import UserAvatar from '../../User/UserAvatar'
import { Trans } from 'react-i18next'
import Moment from 'react-moment'
import UserLink from '../../Shared/UserLink'
import RichText from '../../Shared/RichText'
import MarkdownEditor from '../../Shared/MarkdownEditor'
import M from 'materialize-css'

class DiscussionReplyForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      content: '',
      submitting: false,
      error: "",
    }
  }

  canReply(user) {
    if (!user) {
      return false
    }

    return true
  }

  handleReplyChange(content) {
    this.setState({ content, error: "" })
  }

  handleSubmit(e) {
    e.preventDefault()

    let { content } = this.state
    let error = ""

    if (!content) return

    this.setState({ submitting: true, error })

    setTimeout(() => {
      if (content !== "ERR") {
        content = ""
        M.toast({html: "Reply submitted!", displayLength: 3000, classes: 'green'})
      } else {
        error = "Something did not go so well, no?"
      }
      this.setState({ submitting: false, error, content })
    }, 3000)
  }

  render() {
    const { currentUser } = this.props

    if (!this.canReply(currentUser)) {
      return null
    }

    return (
      <div className={'margin-top--medium forum-post--reply'}>
        <UserAvatar user={currentUser} character={undefined} />

        <div className={'reply-content card sp'}>
          <div className={'reply-content card-content padding--none'}>
            <MarkdownEditor
              placeholder="Enter a reply here, please."
              content={this.state.content}
              hashtags
              readOnly={this.state.submitting}
              onChange={this.handleReplyChange.bind(this)}
            />
          </div>

          { this.state.error && <div className={'error card-action red-text'}>
            <strong>Error:</strong> { this.state.error }
          </div> }

          <div className={'card-action'}>
            Posting as: <a href={'#'}>Administrator</a>
            <button
              className={'btn btn-primary right'}
              disabled={!this.state.content || this.state.submitting}
              onClick={this.handleSubmit.bind(this)}
            >
              {this.state.submitting ? 'Posting...' : 'Post Reply'}
            </button>
          </div>
        </div>

        <div className={'muted text-light margin-top--medium center'}>
          Did you read the rules??
        </div>
      </div>
    )
  }
}

DiscussionReplyForm.propTypes = {
  discussion: PropTypes.object.isRequired,
  forum: PropTypes.object.isRequired,
  refetch: PropTypes.func,
}

export default compose(withCurrentUser())(DiscussionReplyForm)
