import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Input, Row, Column } from 'react-materialize'
import c from 'classnames'

class DeleteUser extends Component {
  constructor(props) {
    super(props)

    this.state = {
      username: null,
      isOpen: false
    }

    this.toggleOpen = this.toggleOpen.bind(this)
    this.handleUserChange = this.handleUserChange.bind(this)
  }

  toggleOpen(e) {
    e.preventDefault()
    this.setState({isOpen: !this.state.isOpen})
  }

  handleUserChange(e) {
    const username = e.target.value
    this.setState({username})
  }

  render() {
    const {
      first,
      user: {
        username
      }
    } = this.props

    const {
      username: usernameConfirm,
      isOpen
    } = this.state

    const disabled = usernameConfirm !== username

    const body = [
      <div className='card-content' key='content'>
        <p className='margin-bottom--large'>
          If you are <strong>absolutely</strong> sure you want to do this,
          you can delete your account. THIS WILL REMOVE ALL YOUR CHARACTERS,
          and NOTHING will be recovered. Please be sure you have a backup of
          your art.
        </p>
        <Row>
          <Input
              s={12}
              type='text'
              name='username'
              label='Username Confirmation'
              onChange={this.handleUserChange}
              error={ disabled && 'Please type your username to confirm delete.' }
          />
        </Row>
      </div>,
      <div className='card-action right-align' key='action'>
        <Button className='red' type='submit' disabled={disabled}>Delete Account</Button>
      </div>
    ]

    return(
        <form className={c('card sp', {'margin-top--large': !first})}>
          <div className='card-header' onClick={this.toggleOpen} style={{ cursor: 'pointer' }}>
            <h2 className='red-text'>Delete Account</h2>
          </div>

          { isOpen && body }
        </form>
    )
  }
}

DeleteUser.propTypes = {
  first: PropTypes.bool,
  user: PropTypes.shape({
    username: PropTypes.string.isRequired
  })
}

export default DeleteUser
