import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'
import { Query } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import NewMessage from './NewMessage'

class NewConversation extends Component {
  constructor(props) {
    super(props)

    this.state = {
      username: this.props.username,
      doSearch: !!this.props.username,
    }

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleUsernameChange = this.handleUsernameChange.bind(this)
    this.handleClose = this.handleClose.bind(this)
    this.handleKeyPress = this.handleKeyPress.bind(this)
    this.handleReset = this.handleReset.bind(this)
  }

  handleUsernameChange(e) {
    e.preventDefault()
    this.setState({ username: e.target.value })
  }

  handleReset(e) {
    if (e && e.preventDefault) e.preventDefault()
    this.setState({ username: '', doSearch: false })
  }

  handleSubmit(e) {
    e.preventDefault()
    if (this.state.username !== '') this.setState({ doSearch: true })
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
    const { doSearch, username } = this.state

    if (!doSearch) {
      return (
        <form onSubmit={this.handleSubmit}>
          <button type="button" onClick={this.handleClose}>
            <Icon>close</Icon>
          </button>

          <input
            name="username"
            type="text"
            onChange={this.handleUsernameChange}
            onKeyDown={this.handleKeyPress}
            value={username}
            placeholder="Username"
            autoFocus
          />

          <button type="submit" disabled={username === ''}>
            <Icon>add</Icon>
          </button>
        </form>
      )
    } else {
      const FIND_USER_QUERY = gql`
        query findUser($username: String!) {
          findUser(username: $username) {
            id
            name
            username
            avatar_url
            is_admin
            is_patron
          }
        }
      `

      const renderResult = ({ loading, data }) => {
        if (loading) {
          return (
            <div className="chat-footer">
              <span>Finding user...</span>
            </div>
          )
        } else {
          const { findUser: user } = data

          if (user) {
            return (
              <div className="chat-search-results">
                <div className="chat-footer highlight">
                  <span>
                    To: {user.name} (@{user.username})
                  </span>
                </div>
                <NewMessage
                  recipientId={user.id}
                  recipient={user}
                  onClose={this.handleReset}
                  onConversationStart={this.props.onConversationStart}
                />
              </div>
            )
          } else {
            return (
              <div className="chat-footer">
                <a className="btn left" onClick={this.handleReset}>
                  <Icon>close</Icon>
                </a>
                <span>User not found.</span>
              </div>
            )
          }
        }
      }

      return (
        <Query query={FIND_USER_QUERY} variables={{ username }}>
          {renderResult}
        </Query>
      )
    }
  }
}

NewConversation.propTypes = {
  onClose: PropTypes.func.isRequired,
  onConversationStart: PropTypes.func,
}

export default NewConversation
