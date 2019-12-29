import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withNamespaces } from 'react-i18next'
import sendKarma from './sendKarma.graphql'
import compose, { withMutations } from '../../../utils/compose'
import gdQuery from '../getDiscussions.graphql'
import M from 'materialize-css'

class KarmaButton extends Component {
  constructor(props) {
    super(props)

    this.state = {
      loading: false,
    }
  }

  handleClick(e) {
    e.preventDefault()
    this.setState({ loading: true })

    const { postId, give, forumId, sendKarma } = this.props

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

        this.setState({ loading: true })
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
  voted: PropTypes.bool,
}

export default compose(
  withMutations({ sendKarma }),
  withNamespaces('common')
)(KarmaButton)
