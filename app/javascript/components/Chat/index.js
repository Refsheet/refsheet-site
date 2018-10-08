import React, { Component } from 'react'
import { gql } from 'apollo-client-preset'
import { Icon } from 'react-materialize'
import Conversations from './Conversations'
import Conversation from './Conversation'
import c from 'classnames'

class Chat extends Component {
  constructor(props) {
    super(props)

    this.state = {
      isOpen: false,
      activeConversationId: null,
      activeConversationUsername: null
    }

    this.handleOpenClose = this.handleOpenClose.bind(this)
    this.handleConversationChange = this.handleConversationChange.bind(this)
  }

  handleOpenClose(e) {
    e.preventDefault()
    this.setState({isOpen: !this.state.isOpen})
  }

  handleConversationChange({id, username}) {
    let activeConversationId = null
    let activeConversationUsername = null

    if(typeof id !== 'undefined' && id !== null) {
      activeConversationId = id
    } else if(typeof username !== 'undefined' && username !== null) {
      activeConversationUsername = username
    }

    this.setState({activeConversationId, activeConversationUsername})
  }

  render() {
    const {
        isOpen,
        activeConversationId,
        activeConversationUsername
    } = this.state

    let title, body

    if(activeConversationId !== null) {
      title = 'Conversation ' + activeConversationId
      body = <Conversation key={activeConversationId} id={activeConversationId} onClose={this.handleConversationChange} />
    } else if(activeConversationUsername !== null) {
      title = 'Conversation with ' + activeConversationUsername
      body = <Conversation username={activeConversationUsername} onClose={this.handleConversationChange} />
    } else {
      title = 'Conversations'
      body = <Conversations onConversationSelect={this.handleConversationChange} />
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

      { isOpen && body }
    </div>)
  }
}

Chat.propTypes = {

}

export default Chat
