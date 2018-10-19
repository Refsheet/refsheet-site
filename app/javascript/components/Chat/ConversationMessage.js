import React from 'react'
import c from 'classnames'
import Moment from 'moment'
import { Icon } from 'react-materialize'
import { Twemoji } from 'react-emoji-render'

const EMOTE_PREFIX_REGEX = /^\/me\s+/

export const formatBody = (message, prefixYou = false) => {
  let {
    message: body = ''
  } = message

  const {
    user: {
      name: userName
    },
    is_self: isSelf
  } = message

  const RenderEmoji = ({children}) =>
      <Twemoji text={children} onlyEmojiClassName={'only-emoji'} />

  if(body.match(EMOTE_PREFIX_REGEX)) {
    return <span>
      <span className='emote-prefix'>{ userName } </span>
      <RenderEmoji>{ body.replace(EMOTE_PREFIX_REGEX, '') }</RenderEmoji>
    </span>

  } else if(prefixYou && isSelf) {
    return <span>
      <span className="self-title">You: </span>
      <RenderEmoji>{body}</RenderEmoji>
    </span>

  } else {
    return <RenderEmoji>{ body }</RenderEmoji>
  }
}

const ConversationMessage = ({ message }) => {
  const {
    guid,
    created_at,
    is_self: isSelf,
    unread,
    message: body
  } = message

  let readIcon, isEmote

  const timeDisplay = (full=false) => {
    const m = Moment.unix(created_at)
    if (full) {
      return m.format('llll')
    } else {
      return m.format('h:mm A')
    }
  }

  if(isSelf) {
    if(!unread) {
      readIcon = <Icon>check</Icon>
    } else if(typeof guid !== 'undefined') {
      readIcon = <Icon>check</Icon>
    }
  }

  if(body.match(EMOTE_PREFIX_REGEX)) {
    isEmote = true
  }

  return (<li className={ c('chat-message', { unread: unread, self: isSelf, emote: isEmote }) }>
    <div className='message'>{ formatBody(message) }</div>
    <div className='time right' title={timeDisplay(true)}>
      { timeDisplay() }
      { readIcon }
      </div>
  </li>)
}

export default ConversationMessage
