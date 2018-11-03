import React from 'react'
import PropTypes from 'prop-types'
import Conversation from './Conversation'
import { connect } from 'react-redux'

const ConversationTray = ({openConversations}) => {
  console.log({openConversations})

  const renderConversation = (id) => {
    return <div key={id} className='chat-popout'>
      <Conversation id={id} onClose={console.log} />
    </div>
  }

  return (
      <div className='chat-tray'>
        { openConversations.map(id => renderConversation(id)) }
      </div>
  )
}

ConversationTray.propTypes = {}

const mapStateToProps = ({conversations}, props) => ({
  ...props,
  openConversations: conversations.openConversations
})

export default connect(mapStateToProps)(ConversationTray)
