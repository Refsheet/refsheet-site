import React from 'react'

const Conversations = ({handleFormSubmit, messages}) => (
    <div className='chat-body conversations'>
      <div className='card-content'>
        Messages: {JSON.stringify(messages)}
      </div>
      <form onSubmit={handleFormSubmit} autoComplete="off" className='reply-box'>
        <textarea name='message' className='browser-default margin--none min-height overline block' placeholder='Send a message...' />
        <button type='submit' value='Send' className='btn btn-square'>
          <Icon>send</Icon>
        </button>
      </form>
    </div>
)

export default Conversations
