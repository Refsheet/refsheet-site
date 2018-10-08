import React from 'react'
import { format as n } from '../../utils/NumberUtils'
import c from 'classnames'
import Moment from 'moment'
import { Icon } from 'react-materialize'

const ConversationMessage = ({ message }) => {
  const {
    guid,
    message: body,
    created_at,
    is_self
  } = message

  const isUnread = body.match(/a/)
  let readIcon

  const timeDisplay = (full=false) => {
    const m = Moment.unix(created_at)
    if (full) {
      return m.format('llll')
    } else {
      return m.format('h:mm A')
    }
  }

  if(is_self) {
    if(!isUnread) {
      readIcon = <Icon>check</Icon>
    } else if(typeof guid !== 'undefined') {
      readIcon = <Icon>check</Icon>
    }
  }

  return (<li className={ c('chat-message', { unread: isUnread, self: is_self }) }>
    <div className='message'>{ body }</div>
    <div className='time right' title={timeDisplay(true)}>
      { timeDisplay() }
      { readIcon }
      </div>
  </li>)
}

export default ConversationMessage
