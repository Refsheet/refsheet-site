import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Mutation, Query } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import _ from 'underscore'
import ConversationMessage from './ConversationMessage'
import NewMessage from './NewMessage'
import { Icon } from 'react-materialize'
import c from 'classnames'

class Conversation extends Component {
  constructor(props) {
    super(props)

    this.unreadBookmark = null
    this.endOfMessages = null
    this.messageWindow = null
    this.userLockedScroll = false

    this.state = {
      isAtBottom: false,
      lastReadMessage: 0
    }

    this.handleConversationClose = this.handleConversationClose.bind(this)
    this.handleScroll = this.handleScroll.bind(this)
    this.scrollToBottom = this.scrollToBottom.bind(this)
  }

  componentDidMount() {
    if(this.props.onMount) this.props.onMount()
    this.scrollToBottom(true)
  }

  componentWillUpdate(newProps) {
    if(newProps.messages.length > this.props.messages.length)
      this.userLockedScroll = !this.isAtBottom()
  }

  componentDidUpdate(newProps, newState) {
    if(newState.isAtBottom === this.state.isAtBottom)
      this.scrollToBottom(true)
  }

  scrollToBottom(toUnread=false, force=false) {
    if(this.userLockedScroll && !force) return

    if(toUnread && this.unreadBookmark) {
      this.unreadBookmark.scrollIntoView()
      if(this.state.isAtBottom !== this.isAtBottom())
        this.setState({isAtBottom: this.isAtBottom()})
    } else if(this.endOfMessages) {
      this.endOfMessages.scrollIntoView()
    }
  }

  isAtBottom() {
    if(!this.messageWindow) return false

    const {
      scrollHeight,
      scrollTop,
      clientHeight
    } = this.messageWindow

    return Math.floor(scrollHeight - scrollTop) <= clientHeight
  }

  handleScroll() {
    const bottom = this.isAtBottom()
    const focus = document.hasFocus()
    this.userLockedScroll = !bottom || !!this.unreadBookmark

    if(bottom !== this.state.isAtBottom)
      this.setState({isAtBottom: bottom})

    if (bottom && focus && this.unreadBookmark) {
      this.markAsRead()
    }
  }

  markAsRead() {
    this.props.updateConversation({
      variables: {
        conversationId: this.props.id
      }
    }).then((e) => {
      if(e.errors) {
        e.errors.map(console.error)
      } else {
        const { messages } = this.props
        if(messages) {
          const lastMessage = messages[messages.length - 1]
          this.setState({lastReadMessage: lastMessage.id})
        }
      }
    })
  }

  handleConversationClose() {
    this.props.onClose({})
  }

  render() {
    const {
      messages = [],
      id: conversationId
    } = this.props

    this.unreadBookmark = null

    let isRead = true
    const renderedMessages = []

    _.sortBy(messages, 'created_at').map((message) => {
      if(message.unread && message.id > this.state.lastReadMessage && isRead) {
        renderedMessages.push(
            <li key='EOM' className='chat-end-of-messages more' ref={(r) => this.unreadBookmark = r}>
              Unread:
            </li>
        )

        isRead = false
      }

      renderedMessages.push(<ConversationMessage key={message.guid} message={message} />)
    })

    renderedMessages.push(
        <li key='EOF' className='chat-end-of-messages clearfix' ref={(r) => this.endOfMessages = r} />
    )

    return (<div className='chat-body conversation'>
      <ul className={c('message-list chat-list')}
          onScroll={this.handleScroll}
          ref={(r) => this.messageWindow = r}>
        { renderedMessages }
      </ul>

      { this.state.isAtBottom ||
        <div className='chat-more-pill' onClick={(e) => this.scrollToBottom(false, true)}>
          <Icon>keyboard_arrow_down</Icon>
        </div> }

      <NewMessage
          onClose={this.handleConversationClose}
          conversationId={conversationId}
      />
    </div>)
  }
}

const renderConversation = (props) => ({loading, data, error, subscribeToMore}) => {
  if (loading) {
    return <div className='chat-loading'>Loading...</div>
  } else if (!data) {
    console.error({error})
    return <div className='chat-loading error red-text'>{error.message}</div>
  } else {
    const subscribe = () => {
      subscribeToMore({
        document: MESSAGES_SUBSCRIPTION,
        variables: { conversationId: props.id },
        updateQuery: (prev, { subscriptionData }) => {
          if (!subscriptionData.data) return prev;
          const { newMessage } = subscriptionData.data

          return Object.assign({}, prev, {
            getMessages: [
              ...prev.getMessages,
              newMessage
            ]
          })
        }
      })
    }

    return <Mutation mutation={UPDATE_CONVERSATION_MUTATION}>
      { (updateConversation, { mutationData }) =>
          <Conversation
              { ...props }
              messages={ data.getMessages }
              onMount={ subscribe }
              updateConversation={updateConversation}
              mutationData={mutationData}
          />
      }
    </Mutation>
  }
}

const MESSAGES_QUERY = gql`
    query getMessages($conversationId: ID!) {
        getMessages(conversationId: $conversationId) {
            id
            guid
            message
            created_at
            is_self
            unread
            user { name }
        }
    }
`
const MESSAGES_SUBSCRIPTION = gql`
    subscription onNewMessage($conversationId: ID!) {
        newMessage(conversationId: $conversationId) {
            id
            guid
            message
            created_at
            is_self
            unread
            user { name }
        }
    }
`

const UPDATE_CONVERSATION_MUTATION = gql`
  mutation updateConversation($conversationId: ID!) {
      updateConversation(conversation_id: $conversationId, read: true) {
          guid
          unreadCount
      }
  }
`

const Wrapped = (props) => (
    <Query query={MESSAGES_QUERY} variables={{conversationId: props.id, conversationUsername: props.username}}>
        {renderConversation(props)}
    </Query>
)

Wrapped.propTypes = {
  onClose: PropTypes.func.isRequired,
  onMount: PropTypes.func
}

export default Wrapped
