import React from 'react'
import { gql } from 'apollo-client-preset'
import { Subscription, Mutation } from 'react-apollo'


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


const Chat = ({data}) => {
  return (<div className='chat-popout'>
    Messages: {JSON.stringify(data)}
    <Mutation mutation={MESSAGE_MUTATION}>
      { (send, {idata}) => (
        <form onSubmit={
          (e)=>{
            e.preventDefault();
            send({variables: {recipientId:1, message:e.target.elements["message"].value}})
          }
        }>
          Data: { JSON.stringify(idata) }
          <input name='message' className='browser-default' />
          <input type='submit' value='>' />
        </form>
      )}
    </Mutation>
  </div>)
}

const Wrapped = (props) => (
    <Subscription subscription={MESSAGES_SUBSCRIPTION}>
      {(data,b,c,d) => (<Chat {...props} data={{data,b,c,d}} />) }
    </Subscription>
)

export default Wrapped
