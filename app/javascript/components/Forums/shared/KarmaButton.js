import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {withNamespaces} from "react-i18next";
import sendKarma from "./sendKarma.graphql"
import {Mutation} from "react-apollo";

const KarmaButton = ({t, postId, give, take, disabled, voted}) => {
  let title, icon;

  if (give) {
    title = t('forums.karma.give', "Give Karma")
    icon  = "keyboard_arrow_up"
  } else {
    title = t('forums.karma.take', "Take Karma")
    icon  = "keyboard_arrow_down"
  }

  if (disabled) {
    return (
      <span title={title}>
        <Icon>{ icon }</Icon>
      </span>
    )
  }

  const variables = {
    postId: postId,
    take: !give
  }

  const onClick = (send) => (e) => {
    e.preventDefault()
    send(variables)
  }

  const renderLink = (send, { called, loading, data, error }) => {
    return(<a href={'#'} title={title} onClick={onClick}>
      <Icon>{icon}</Icon>
      {JSON.stringify(data)}
    </a>)
  }

  return (
    <Mutation mutation={sendKarma}>
      { renderLink }
    </Mutation>
  )
}

KarmaButton.propTypes = {
  postId: PropTypes.string.isRequired,
  give: PropTypes.bool,
  take: PropTypes.bool,
  disabled: PropTypes.bool,
  voted: PropTypes.bool
}

export default withNamespaces('common')(KarmaButton)