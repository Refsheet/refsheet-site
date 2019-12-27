import React, { Component } from 'react'
import { format as n } from '../../utils/NumberUtils'
import c from 'classnames'
import Moment from 'moment'
import { gql } from 'apollo-client-preset/lib/index'
import { Subscription } from 'react-apollo'
import { formatBody } from './ConversationMessage'
import { userClasses } from '../../utils/UserUtils'

class ConversationLink extends Component {
  constructor(props) {
    super(props)
    this.state = {}
  }

  render() {
    const { subscriptionData, conversation, onClick } = this.props

    const data = subscriptionData.data || {}

    console.debug({ subscriptionData })

    const { guid, unreadCount, lastMessage, user } =
      data.conversationChanged || conversation

    const isUnread = unreadCount > 0

    const handleClick = e => {
      e.preventDefault()
      onClick({ id: guid, name: user.name, user: user })
    }

    const usernameDisplay = `@${user.username}`

    const timeDisplay = (full = false) => {
      const m = Moment.unix(lastMessage.created_at)
      if (full) {
        return m.format('llll')
      } else if (m.isSame(Moment(), 'day')) {
        return m.format('h:mm A')
      } else if (m.isSame(Moment(), 'week')) {
        return m.format('ddd')
      } else {
        return m.format('l')
      }
    }

    return (
      <li className={c('chat-conversation', { unread: isUnread })}>
        <a href="#" onClick={handleClick}>
          <img
            src={user.avatar_url}
            alt={usernameDisplay}
            title={usernameDisplay}
            className={c('avatar', userClasses(user))}
          />
          <div className="time" title={timeDisplay(true)}>
            {timeDisplay()}
          </div>
          <div className="title">
            <span title={usernameDisplay} className={userClasses(user)}>
              {user.name}
            </span>
            {isUnread && (
              <span className="unread-count">({n(unreadCount)})</span>
            )}
          </div>
          <div className="last-message">{formatBody(lastMessage, true)}</div>
        </a>
      </li>
    )
  }
}

const CONVERSATION_SUBSCRIPTION = gql`
  subscription conversationChanged($conversationId: ID!) {
    convChanged(convId: $conversationId) {
      id
      unreadCount
      lastMessage {
        message
        created_at
        is_self
        user {
          name
        }
      }
      user {
        name
        username
        avatar_url
        is_admin
        is_patron
      }
    }
  }
`

class Wrapped extends Component {
  render() {
    return (
      <Subscription
        subscription={CONVERSATION_SUBSCRIPTION}
        variables={{ conversationId: this.props.conversation.guid }}
      >
        {subscriptionData => (
          <ConversationLink
            {...this.props}
            subscriptionData={subscriptionData}
          />
        )}
      </Subscription>
    )
  }

  shouldComponentUpdate(newProps) {
    return newProps.conversation.guid !== this.props.conversation.guid
  }
}

export default Wrapped
