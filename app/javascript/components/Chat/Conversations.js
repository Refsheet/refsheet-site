import React from 'react'

const Conversations = ({handleFormSubmit, messages}) => (
    <div className='chat-body conversations'>
      <ul className='chat-list'>
        <li className='chat-conversation'>
          <img src={'https://cloud.refsheet.net/images/images/000/065/797/medium/winterblack_alice_1.png?1528681529'} alt={'MauAbata'} />
          <div className='time'>4:30pm</div>
          <div className='title'>Mau Abata</div>
          <div className='last-message'>So I was wondering, if you could maybe...</div>
        </li>
      </ul>
      {/*<form onSubmit={handleFormSubmit} autoComplete="off" className='reply-box'>*/}
        {/*<textarea name='message' className='browser-default margin--none min-height overline block' placeholder='Send a message...' />*/}
        {/*<button type='submit' value='Send' className='btn btn-square'>*/}
          {/*<Icon>send</Icon>*/}
        {/*</button>*/}
      {/*</form>*/}
    </div>
)

export default Conversations
