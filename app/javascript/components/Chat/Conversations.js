import React from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import { format as n } from 'NumberUtils'
import { Query } from 'react-apollo'
import { gql } from 'apollo-client-preset'

const CONVERSATIONS_QUERY = gql`
  query getConversations {
      getConversations {
          id
          unreadCount
          lastMessage {
              message
          }
      }
  }
`

const Conversations = ({onConversationSelect, conversations, data}) => {
  const renderConversation = ({id, unreadCount, lastMessage}) => {
    const isUnread = unreadCount > 0

    const onClick = (e) => {
      e.preventDefault()
      onConversationSelect(id)
    }

    return (
        <li className={c('chat-conversation', {unread: isUnread})}>
          <a href='#' onClick={onClick}>
            <img src={'https://cloud.refsheet.net/images/images/000/065/797/medium/winterblack_alice_1.png?1528681529'} alt={'MauAbata'} />
            <div className='time'>4:30pm</div>
            <div className='title'>
              Mau Abata

              { isUnread && <span className='unread-count'>({ n(unreadCount) })</span> }
            </div>
            <div className='last-message'>{ lastMessage.message }</div>
          </a>
        </li>
    )
  }

  // const conversations = [
  //   { id: 1, message: "hi", unreadCount: 0 },
  //   { id: 2, message: "hi", unreadCount: 0 },
  //   { id: 3, message: "hi", unreadCount: 3 },
  //   { id: 4, message: "hi", unreadCount: 0 },
  //   { id: 5, message: "hi", unreadCount: 0 },
  //   { id: 6, message: "Hello! Hi! Hello! OMG Chat is totally a thing! OMG HI!", unreadCount: 134542 },
  //   { id: 7, message: "hi", unreadCount: 0 },
  //   { id: 8, message: "hi", unreadCount: 1 },
  //   { id: 9, message: "hi", unreadCount: 0 },
  //   { id: 0, message: "hi", unreadCount: 4 }
  // ]

  return (
      <div className='chat-body conversations'>
        <ul className='chat-list'>
          { conversations && conversations.map(renderConversation) }
        </ul>
        {/*<form onSubmit={handleFormSubmit} autoComplete="off" className='reply-box'>*/}
        {/*<textarea name='message' className='browser-default margin--none min-height overline block' placeholder='Send a message...' />*/}
        {/*<button type='submit' value='Send' className='btn btn-square'>*/}
        {/*<Icon>send</Icon>*/}
        {/*</button>*/}
        {/*</form>*/}
      </div>
  )
}

Conversations.propTypes = {
  onConversationSelect: PropTypes.func.isRequired
}

const Wrapped = (props) => (
    <Query query={CONVERSATIONS_QUERY}>
      {({loading, data}) => (
      loading
          ? <span>Loading...</span>
          : data ? <Conversations {...props} conversations={data.getConversations} loading={loading} />
      : <span>Error.</span>)
      }
    </Query>
)

export default Wrapped
