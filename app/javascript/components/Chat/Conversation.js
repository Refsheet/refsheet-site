import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Query } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import _ from 'underscore'
import ConversationMessage from './ConversationMessage'
import NewMessage from './NewMessage'

class Conversation extends Component {
  constructor(props) {
    super(props)

    this.endOfMessages = null

    this.handleConversationClose = this.handleConversationClose.bind(this)
  }

  componentDidMount() {
    if(this.props.onMount) this.props.onMount()
    if(this.endOfMessages) {
      this.endOfMessages.scrollIntoView()
    }
  }

  handleConversationClose() {
    this.props.onClose({})
  }

  componentDidUpdate() {
    if(this.endOfMessages) {
      this.endOfMessages.scrollIntoView()
    }
  }

  render() {
    const {
      messages = [],
      id: conversationId
    } = this.props

    return (<div className='chat-body conversation'>
      <ul className='message-list chat-list'>
        { _.sortBy(messages, 'created_at').map((message) =>
            <ConversationMessage key={message.guid} message={message} />) }
        <li className='chat-end-of-messages' ref={(r) => this.endOfMessages = r} />
      </ul>

      <NewMessage
          onClose={this.handleConversationClose}
          conversationId={conversationId}
      />
    </div>)
  }
}

const renderConversation = (props) => ({loading, data, error, subscribeToMore}) => {
  if (loading) {
    return <span>Loading...</span>
  } else if (!data) {
    console.error({error})
    return <span>{error.message}</span>
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

    return <Conversation
        {...props}
        messages={data.getMessages}
        onMount={subscribe}
    />
  }
}

const MESSAGES_QUERY = gql`
    query getMessages($conversationId: ID!) {
        getMessages(conversationId: $conversationId) {
            guid
            message
            created_at
            is_self
        }
    }
`
const MESSAGES_SUBSCRIPTION = gql`
    subscription onNewMessage($conversationId: ID!) {
        newMessage(conversationId: $conversationId) {
            guid
            message
            created_at
            is_self
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
