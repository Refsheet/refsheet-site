import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'
import { Mutation } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import * as M from 'materialize-css'
import EmailConfirmationNag from '../User/EmailConfirmationNag'

class NewMessage extends Component {
  constructor(props) {
    super(props)

    this.state = {
      message: '',
    }

    this.nonce = 0

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleMessageChange = this.handleMessageChange.bind(this)
    this.handleClose = this.handleClose.bind(this)
    this.handleKeyPress = this.handleKeyPress.bind(this)
  }

  handleMessageChange(e) {
    e.preventDefault()
    this.setState({ message: e.target.value })
  }

  handleSubmit(e) {
    e.preventDefault()

    const { nonce } = this
    this.nonce += 1

    if (this.props.onCreate) {
      const ctime = new Date().getTime() / 1000

      this.props.onCreate({
        message: this.state.message,
        nonce: nonce,
        status: 'preflight',
        created_at: ctime,
      })
    }

    this.props
      .send({
        variables: {
          conversationId: this.props.conversationId,
          recipientId: this.props.recipientId,
          message: this.state.message,
          nonce: nonce,
        },
      })
      .then(({ data, errors }) => {
        const { onConversationStart } = this.props

        const guid =
          data &&
          data.sendMessage &&
          data.sendMessage.conversation &&
          data.sendMessage.conversation.guid

        const messageGuid = data && data.sendMessage && data.sendMessage.guid

        if (guid && onConversationStart) {
          onConversationStart({
            id: guid,
            name: this.props.recipient.name,
            user: this.props.recipient,
          })
        }

        if (errors) {
          errors.map(error => {
            M.toast({
              html: error.message,
              classes: 'red',
              displayLength: 3000,
            })
          })

          if (this.props.onCreate) {
            this.props.onCreate({
              nonce: nonce,
              status: 'error',
              error: errors[0].message,
            })
          }
        } else if (messageGuid) {
          if (this.props.onCreate) {
            this.props.onCreate({
              nonce: nonce,
              status: 'delivered',
              guid: messageGuid,
            })
          }
        }
      })
      .catch(error => {
        console.error(error)

        if (this.props.onCreate) {
          this.props.onCreate({
            nonce: nonce,
            status: 'error',
            error: error,
          })
        }
      })

    this.setState({ message: '' })
  }

  handleClose(e) {
    e.preventDefault()
    this.props.onClose()
  }

  handleKeyPress(e) {
    if (e.keyCode === 27) {
      this.handleClose(e)
    }
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <button type="button" onClick={this.handleClose}>
          <Icon>close</Icon>
        </button>

        <input
          name="message"
          type="text"
          onChange={this.handleMessageChange}
          onKeyDown={this.handleKeyPress}
          value={this.state.message}
          placeholder="What say you?"
          autoFocus
          autoComplete="off"
        />

        <button type="submit" disabled={this.state.message === ''}>
          <Icon>send</Icon>
        </button>
      </form>
    )
  }
}

const MESSAGE_MUTATION = gql`
  mutation sendMessage(
    $conversationId: ID
    $recipientId: ID
    $message: String!
  ) {
    sendMessage(
      conversationId: $conversationId
      recipientId: $recipientId
      message: $message
    ) {
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
const Wrapped = props => (
  <EmailConfirmationNag slim>
    <Mutation mutation={MESSAGE_MUTATION}>
      {(send, { mutationData }) => (
        <NewMessage {...props} send={send} mutationData={mutationData} />
      )}
    </Mutation>
  </EmailConfirmationNag>
)

Wrapped.propTypes = {
  onClose: PropTypes.func.isRequired,
  onConversationStart: PropTypes.func,
  onCreate: PropTypes.func,
  conversationId: PropTypes.string,
  recipient: PropTypes.shape({
    id: PropTypes.string,
    name: PropTypes.string,
  }),
}

export default Wrapped
