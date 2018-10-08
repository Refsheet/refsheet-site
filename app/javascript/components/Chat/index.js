import React, { Component } from 'react'
import { gql } from 'apollo-client-preset'
import { Subscription, Mutation } from 'react-apollo'
import { Icon } from 'react-materialize'
import Conversations from './Conversations'
import c from 'classnames'

const MESSAGES_SUBSCRIPTION = gql`
    subscription onNewMessage {
        newMessage {
            id
            message
            user { name }
            conversation { guid }
        }
    }
`

const MESSAGE_MUTATION = gql`
  mutation sendMessage($recipientId: ID!, $message: String!) {
      sendMessage(recipientId: $recipientId, message: $message) {
          id
          message
          user { name }
          conversation { guid }
      }
  }
`

class Chat extends Component {
  constructor(props) {
    super(props)

    this.state = {
      messages: [],
      conversations: [],
      isOpen: false,
      activeConversationId: null
    }

    this.handleFormSubmit = this.handleFormSubmit.bind(this)
    this.handleOpenClose = this.handleOpenClose.bind(this)
    this.handleConversationChange = this.handleConversationChange.bind(this)
  }

  handleFormSubmit(e) {
    e.preventDefault()

    const variables = {
      recipientId: 1,
      message: e.target.elements["message"].value
    }

    this.props.send({variables})
  }

  handleOpenClose(e) {
    e.preventDefault()
    this.setState({isOpen: !this.state.isOpen})
  }

  handleConversationChange(id) {
    this.setState({activeConversationId: id})
  }

  render() {
    const {
        messages,
        sent
    } = this.props

    const {
        isOpen,
        activeConversationId
    } = this.state

    let title = 'Conversations'

    if(activeConversationId !== null) {
      title = 'Conversation ' + activeConversationId
    }

    return (<div className={c('chat-popout', {open: isOpen})}>
      <div className='chat-title'>
        <a href='#' className='right white-text' onClick={this.handleOpenClose}>
          <Icon>{ isOpen ? 'keyboard_arrow_down' : 'keyboard_arrow_up' }</Icon>
        </a>
        <a href='#' className='white-text' onClick={this.handleOpenClose}>
          { title }
        </a>
      </div>

      { isOpen &&
        <Conversations onConversationSelect={this.handleConversationChange} /> }
    </div>)
  }
}

const Wrapped = (props) => (
    <Subscription subscription={MESSAGES_SUBSCRIPTION}>
      {(subscriptionData) => (
          <Mutation mutation={MESSAGE_MUTATION}>
            {(send, {mutationData}) => (
                <Chat {...props} messages={subscriptionData} sent={mutationData} send={send} />
            )}
          </Mutation>
      )}
    </Subscription>
)

export default Wrapped
