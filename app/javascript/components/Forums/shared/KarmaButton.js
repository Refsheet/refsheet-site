import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withNamespaces } from 'react-i18next'
import sendKarma from './sendKarma.graphql'
import { Mutation } from 'react-apollo'
import compose, {withMutations} from "../../../utils/compose";

const KarmaButton = ({ t, postId, give, take, disabled, voted, sendKarma }) => {
  let title, icon

  if (give) {
    title = t('forums.karma.give', 'Give Karma')
    icon = 'keyboard_arrow_up'
  } else {
    title = t('forums.karma.take', 'Take Karma')
    icon = 'keyboard_arrow_down'
  }

  if (disabled) {
    return (
      <span title={title}>
        <Icon>{icon}</Icon>
      </span>
    )
  }

  const variables = {
    postId: postId,
    take: !give,
  }

  const onClick = e => {
    e.preventDefault()

    sendKarma({variables})
      .then(console.log)
      .catch(console.error)
  }

  return (
    <a href={'#'} title={title} onClick={onClick}>
      <Icon>{icon}</Icon>
    </a>
  )
}

KarmaButton.propTypes = {
  postId: PropTypes.string.isRequired,
  give: PropTypes.bool,
  take: PropTypes.bool,
  disabled: PropTypes.bool,
  voted: PropTypes.bool,
}

export default compose(
  withMutations({sendKarma}),
  withNamespaces('common')
)(KarmaButton)
