import React from 'react'
import PropTypes from 'prop-types'
import Conversation from './Conversation'
import { connect } from 'react-redux'
import NewConversation from './NewConversation'
import { closeConversation, openConversation } from '../../actions'
import { withErrorBoundary } from '../Shared/ErrorBoundary'
import compose from '../../utils/compose'

const ConversationTray = ({
  openConversations,
  openConversation,
  closeConversation,
}) => {
  const newConversation = conversation => {
    closeConversation()

    if (typeof conversation !== 'undefined') {
      const { id } = conversation
      openConversation(id)
    }
  }

  const renderConversation = id => {
    if (typeof id === 'undefined') {
      return null
    }

    if (typeof id !== 'undefined' && !id.username) {
      return (
        <div key={id} className="chat-popout">
          <Conversation id={id} onClose={console.log} />
        </div>
      )
    }

    return (
      <div key={'new-conversation'} className={'chat-popout unread'}>
        <div className={'chat-title'}>New Conversation</div>
        <div className={'message-list chat-list empty'} />
        <NewConversation
          onClose={newConversation}
          onConversationStart={newConversation}
          username={id && id.username}
        />
      </div>
    )
  }

  return (
    <div className="chat-tray">
      {openConversations.map(id => renderConversation(id))}
    </div>
  )
}

ConversationTray.propTypes = {}

const mapStateToProps = ({ conversations }, props) => ({
  ...props,
  openConversations: conversations.openConversations,
})

const mapDispatchToProps = {
  openConversation,
  closeConversation,
}

export default compose(
  withErrorBoundary,
  connect(mapStateToProps, mapDispatchToProps)
)(ConversationTray)
