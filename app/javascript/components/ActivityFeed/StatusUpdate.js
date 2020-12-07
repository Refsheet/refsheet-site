import React, { Component } from 'react'
import PropTypes from 'prop-types'
import CommentForm from '../Shared/CommentForm'
import CreateActivity from './createActivity.graphql'
import { Mutation } from 'react-apollo'
import { withTranslation } from 'react-i18next'

class StatusUpdate extends Component {
  handleSubmit({ comment, identity }) {
    return this.props.post({
      variables: {
        comment,
        characterId: identity.characterId,
      },
    })
  }

  render() {
    const { t } = this.props

    return (
      <CommentForm
        inCharacter
        placeholder={t('status_update.placeholder', "What's on your mind, %n?")}
        buttonText={t('status_update.post', 'Post')}
        buttonSubmittingText={t('status_update.submitting', 'Sending...')}
        onSubmit={this.handleSubmit.bind(this)}
      />
    )
  }
}

StatusUpdate.propTypes = {}

const withMutation = props => (
  <Mutation mutation={CreateActivity}>
    {(post, data) => <StatusUpdate post={post} data={data} {...props} />}
  </Mutation>
)

export default withTranslation('common')(withMutation)
