import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon } from 'react-materialize'

class NewConversation extends Component {
  constructor(props) {
    super(props)

    this.state = {
      username: ''
    }

    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleUsernameChange = this.handleUsernameChange.bind(this)
    this.handleClose = this.handleClose.bind(this)
    this.handleKeyPress = this.handleKeyPress.bind(this)
  }

  handleUsernameChange(e) {
    e.preventDefault()
    this.setState({username: e.target.value})
  }

  handleSubmit(e) {
    e.preventDefault()
    this.props.onClose(this.state.username)
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

      <input name='username'
             type='text'
             onChange={ this.handleUsernameChange }
             onKeyDown={ this.handleKeyPress }
             value={ this.state.username }
             placeholder='Username'
             autoFocus
      />

      <button type='submit' disabled={this.state.username === ''}>
          <Icon>add</Icon>
      </button>
    </form>)
  }
}

NewConversation.propTypes = {
  onClose: PropTypes.func.isRequired
}

export default NewConversation
