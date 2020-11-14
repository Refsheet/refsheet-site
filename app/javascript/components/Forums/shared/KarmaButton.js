import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import sendKarma from './sendKarma.graphql'
import compose, { withMutations } from '../../../utils/compose'
import gdQuery from '../getDiscussions.graphql'
import M from 'materialize-css'

import Icon from 'v1/shared/material/Icon'

class KarmaButton extends Component {
  constructor(props) {
    super(props)

    this.state = {
      loading: false,
    }
  }

  handleClick(e) {
    e.preventDefault()
    const { postId, give, forumId, sendKarma, onLoading } = this.props

    onLoading(true)

    const variables = {
      postId: postId,
      take: !give,
    }

    sendKarma({
      variables,
      update: (cache, { data: { sendKarma } }) => {
        const { getForum } = cache.readQuery({
          query: gdQuery,
          variables: {
            forumId: forumId,
          },
        })

        cache.writeQuery({
          query: gdQuery,
          data: {
            getForum: {
              ...getForum,
              discussions: getForum.discussions.map(d => {
                if (d.id === sendKarma.id) {
                  return { ...d, karma_total: sendKarma.karma_total }
                } else {
                  return d
                }
              }),
            },
          },
        })
      },
    })
      .then(({ data, errors }) => {
        if (errors) {
          M.toast({
            html: 'Something went wrong sending that karma...',
            classes: 'red',
          })
          console.error(errors)
        }

        onLoading(false)
      })
      .catch(console.error)
  }

  render() {
    const { t, give, disabled } = this.props
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

    return (
      <a href={'#'} title={title} onClick={this.handleClick.bind(this)}>
        <Icon>{icon}</Icon>
      </a>
    )
  }
}

KarmaButton.propTypes = {
  postId: PropTypes.string.isRequired,
  forumId: PropTypes.string.isRequired,
  give: PropTypes.bool,
  take: PropTypes.bool,
  disabled: PropTypes.bool,
  onLoading: PropTypes.func,
  voted: PropTypes.bool,
}

export default compose(
  withMutations({ sendKarma }),
  withTranslation('common')
)(KarmaButton)
