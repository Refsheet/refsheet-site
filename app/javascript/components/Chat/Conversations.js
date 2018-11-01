import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Query } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import _ from 'underscore'

import ConversationLink from './ConversationLink'
import NewConversation from './NewConversation'

class Conversations extends Component {
  constructor(props) {
    super(props)

    this.state = {
      filter: null,
      startNew: false
    }

    this.handleNewConversationClick = this.handleNewConversationClick.bind(this)
    this.handleNewConversationClose = this.handleNewConversationClose.bind(this)
  }

  componentDidMount() {
    if(this.props.onMount) this.props.onMount()
  }

  handleNewConversationClick(e) {
    e.preventDefault()
    this.setState({startNew: true})
  }

  handleNewConversationClose(username = null) {
    this.setState({startNew: false})

    if(username) {
      this.props.onConversationSelect({username})
    }
  }

  render() {
    const {
      conversations = [],
      onConversationSelect
    } = this.props

    return (<div className='chat-body conversations'>
      <ul className='chat-list padding--none'>
        { _.sortBy(
            conversations, (c) => c.lastMessage && c.lastMessage.created_at
        ).reverse().map((conversation) =>
            <ConversationLink key={conversation.id} conversation={conversation} onClick={onConversationSelect} />) }
      </ul>
      { this.state.startNew
          ? <NewConversation onClose={this.handleNewConversationClose} onConversationStart={onConversationSelect} />
          : <div className='btn btn-flat new-conversation' onClick={this.handleNewConversationClick}>
              New Conversation
            </div> }
    </div>)
  }
}

const CONVERSATIONS_FIELDS = gql`
    fragment ConversationsFields on Conversation {
        id
        guid
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
`

const CONVERSATIONS_QUERY = gql`
    ${CONVERSATIONS_FIELDS}
    
    query getConversations {
        getConversations {
            ...ConversationsFields
        }
    }
`
const CONVERSATIONS_SUBSCRIPTION = gql`
    ${CONVERSATIONS_FIELDS}
    
    subscription subscribeToConversations {
        newConversation {
            ...ConversationsFields
        }
    }
`

const renderConversations = (props) => ({loading, data, subscribeToMore}) => {
  if (loading) {
    return <div className='chat-loading'>Loading...</div>
  } else if (!data) {
    return <div className='chat-loading error red-text'>Error.</div>
  } else {
    const subscribe = () => {
      subscribeToMore({
        document: CONVERSATIONS_SUBSCRIPTION,
        updateQuery: (prev, { subscriptionData }) => {
          if (!subscriptionData.data) return prev;
          const { newConversation } = subscriptionData.data

          return Object.assign({}, prev, {
            getConversations: [
              ...prev.getConversations,
              newConversation
            ]
          })
        }
      })
    }

    return <Conversations
        {...props}
        conversations={data.getConversations}
        onMount={subscribe}
    />
  }
}


const Wrapped = (props) => (
    <Query query={CONVERSATIONS_QUERY}>
      {renderConversations(props)}
    </Query>
)

Wrapped.propTypes = {
  onConversationSelect: PropTypes.func.isRequired,
  onMount: PropTypes.func
}

export default Wrapped
