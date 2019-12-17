import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { gql } from 'apollo-client-preset'
import { Icon } from 'react-materialize'
import Conversations from './Conversations'
import Conversation from './Conversation'
import c from 'classnames'
import { format as f } from 'NumberUtils'
import WindowAlert from 'WindowAlert'
import { Query, Subscription } from 'react-apollo'
import { userClasses } from '../../utils/UserUtils'

class Chat extends Component {
  constructor(props) {
    super(props)

    const isOpen = window.location.hash.match(/^#chat\b/)

    this.state = {
      isOpen,
      activeConversationId: null,
      activeConversationName: null,
      activeConversationUser: null,
    }

    this.handleOpenClose = this.handleOpenClose.bind(this)
    this.handleConversationChange = this.handleConversationChange.bind(this)
  }

  componentWillUnmount() {
    WindowAlert.clear('chat')
  }

  handleOpenClose(e) {
    e.preventDefault()

    if (!this.state.isOpen) {
      window.location.hash = '#chat'
    } else {
      window.location.hash = ''
    }

    this.setState({
      isOpen: !this.state.isOpen,
      activeConversationId: null,
      activeConversationName: null,
      activeConversationUser: null,
    })
  }

  handleConversationChange({ id, name, user }) {
    let activeConversationId = null

    if (typeof id !== 'undefined' && id !== null) {
      activeConversationId = id
      window.location.hash = `chat:${id}`
    } else {
      window.location.hash = 'chat'
    }

    this.setState({
      activeConversationId,
      activeConversationName: name,
      activeConversationUser: user,
    })
  }

  render() {
    const {
      isOpen,
      activeConversationId,
      activeConversationName,
      activeConversationUser: user,
    } = this.state

    const { unread } = this.props

    let title, body, isUnread

    const name =
      activeConversationName && activeConversationId
        ? `Conversation with ${activeConversationName}`
        : 'Conversations'

    if (unread) {
      title = `${name} (${f(unread)})`
      isUnread = true
      WindowAlert.add('chat', `${f(unread)} New Messages`, unread)
    } else {
      title = name
      WindowAlert.clear('chat')
    }

    if (activeConversationId !== null) {
      body = (
        <Conversation
          user={user}
          key={activeConversationId}
          id={activeConversationId}
          onClose={this.handleConversationChange}
        />
      )
    } else {
      body = (
        <Conversations onConversationSelect={this.handleConversationChange} />
      )
    }

    return (
      <div className={c('chat-popout', { open: isOpen, unread: isUnread })}>
        <div
          className={c(
            'chat-title',
            !isUnread && userClasses(user, 'user-background-light')
          )}
        >
          <a
            href="#"
            className="right white-text"
            onClick={this.handleOpenClose}
          >
            <Icon>{isOpen ? 'keyboard_arrow_down' : 'keyboard_arrow_up'}</Icon>
          </a>
          <a href="#" className="white-text" onClick={this.handleOpenClose}>
            {title}
          </a>
        </div>

        {isOpen && body}
      </div>
    )
  }
}

const CHAT_COUNT_SUBSCRIPTION = gql`
  subscription chatCountsChanged {
    chatCountsChanged {
      unread
    }
  }
`

const CHAT_COUNT_QUERY = gql`
  query chatCounts {
    chatCounts {
      unread
    }
  }
`

const Wrapped = props => {
  return (
    <Subscription subscription={CHAT_COUNT_SUBSCRIPTION}>
      {({ data: subscriptionData }) => (
        <Query query={CHAT_COUNT_QUERY}>
          {({ data: queryData }) => {
            const counts = (subscriptionData &&
              subscriptionData.chatCountsChanged) ||
              (queryData && queryData.chatCounts) || { unread: 0 }

            return <Chat {...props} unread={counts.unread} />
          }}
        </Query>
      )}
    </Subscription>
  )
}

Chat.propTypes = {
  unread: PropTypes.number,
}

export default Wrapped
