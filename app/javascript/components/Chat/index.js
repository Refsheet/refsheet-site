import React from 'react'
import { gql } from 'apollo-client-preset'
import { Subscription } from 'react-apollo'


const COMMENTS_SUBSCRIPTION = gql`
    subscription onNewMessage {
        newMessage {
            id
            message
            user { name }
            conversation { guid }
        }
    }
`;


const Chat = ({data}) => {
  return (<div className='chat-popout'>
    Messages: {JSON.stringify(data)}
  </div>)
}

const Wrapped = (props) => (
    <Subscription subscription={COMMENTS_SUBSCRIPTION}>
      {(data) => (<Chat {...props} data={data} />) }
    </Subscription>
)

export default Wrapped
