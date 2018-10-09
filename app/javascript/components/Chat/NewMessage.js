import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'
import { Mutation } from 'react-apollo'
import { gql } from 'apollo-client-preset'

class NewMessage extends Component {
  constructor(props) {
    super(props)

    this.state = {
      message: ''
    }

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleMessageChange = this.handleMessageChange.bind(this)
    this.handleClose = this.handleClose.bind(this)
    this.handleKeyPress = this.handleKeyPress.bind(this)
  }

  handleMessageChange(e) {
    e.preventDefault()
    this.setState({message: e.target.value})
  }

  handleSubmit(e) {
    e.preventDefault()

    this.props.send({
      variables: {
        conversationId: this.props.conversationId,
        recipientId: this.props.recipientId,
        message: this.state.message
      }
    }).then(({data}) => {
      const {
        onConversationStart
      } = this.props

      const guid = (
          data &&
              data.sendMessage &&
              data.sendMessage.conversation &&
              data.sendMessage.conversation.guid
      )

      if(guid && onConversationStart)
        onConversationStart({id: guid})
    })

    this.setState({message: ''})
  }

  handleClose(e) {
    e.preventDefault()
    this.props.onClose()
  }

  handleKeyPress(e) {
    if(e.keyCode === 27) {
      this.handleClose(e)
    }
  }

  render() {
    return (<form onSubmit={ this.handleSubmit }>
      <button type="button" onClick={ this.handleClose }>
        <Icon>close</Icon>
      </button>

      <input name='message'
             type='text'
             onChange={ this.handleMessageChange }
             onKeyDown={ this.handleKeyPress }
             value={ this.state.message }
             placeholder='What say you?'
             autoFocus
             autoComplete='off'
      />

      <button type='submit' disabled={this.state.message === ''}>
        <Icon>send</Icon>
      </button>
    </form>)
  }
}

const MESSAGE_MUTATION = gql`
    mutation sendMessage($conversationId: ID, $recipientId: ID, $message: String!) {
        sendMessage(conversationId: $conversationId, recipientId: $recipientId, message: $message) {
            guid
            message
            created_at
            read_at
            conversation {
                guid
            }
        }
    }
`
const Wrapped = (props) => (
    <Mutation mutation={MESSAGE_MUTATION}>
      {(send, {mutationData}) => (
          <NewMessage {...props} send={send} mutationData={mutationData} />
      )}
    </Mutation>
)

Wrapped.propTypes = {
  onClose: PropTypes.func.isRequired,
  onConversationStart: PropTypes.func,
  conversationId: PropTypes.string.isRequired
}

export default Wrapped
