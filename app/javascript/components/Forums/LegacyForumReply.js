import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import { Mutation } from 'react-apollo'
import postReply from './postReply.graphql'
import CommentForm from '../Shared/CommentForm'
import { withTranslation } from 'react-i18next'

class LegacyForumReply extends Component {
  constructor(props) {
    super(props)
  }

  handleSubmit({ comment, identity }) {
    return this.props.post({
      variables: {
        content: comment,
        characterId: identity.characterId,
        discussionId: this.props.discussionId,
      },
    })
  }

  handleSubmitConfirm({ postReply }) {
    this.props.onPost(postReply)
  }

  render() {
    if (!this.props.currentUser) {
      return null
    }

    const { t } = this.props

    return (
      <CommentForm
        inCharacter
        placeholder={t('forums.reply-placeholder', 'Write a reply, %n.')}
        buttonText={t('forums.reply', 'Reply')}
        buttonSubmittingText={t('status_update.submitting', 'Sending...')}
        onSubmit={this.handleSubmit.bind(this)}
        onSubmitConfirm={this.handleSubmitConfirm.bind(this)}
      />
    )
  }
}

LegacyForumReply.propTypes = {
  discussionId: PropTypes.number.isRequired,
  onPost: PropTypes.func,
}

const withMutation = props => (
  <Mutation mutation={postReply}>
    {(post, data) => <LegacyForumReply {...props} post={post} data={data} />}
  </Mutation>
)

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
})

export default connect(mapStateToProps)(withTranslation('common')(withMutation))
