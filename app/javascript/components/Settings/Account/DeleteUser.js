import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Input, Row, Col, Button } from 'react-materialize'
import c from 'classnames'
import { Mutation } from 'react-apollo'
import { gql } from 'apollo-client-preset'
import { withRouter } from 'react-router'
import compose, { withCurrentUser } from '../../../utils/compose'

class DeleteUser extends Component {
  constructor(props) {
    super(props)

    this.state = {
      username: '',
      password: '',
      errors: [],
      isOpen: false,
      isSubmitting: false,
    }

    this.toggleOpen = this.toggleOpen.bind(this)
    this.handleUserChange = this.handleUserChange.bind(this)
    this.handlePasswordChange = this.handlePasswordChange.bind(this)
    this.handleFormSubmit = this.handleFormSubmit.bind(this)
  }

  toggleOpen(e) {
    e.preventDefault()
    this.setState({ isOpen: !this.state.isOpen })
  }

  handleUserChange(e) {
    e.preventDefault()
    const username = e.target.value
    this.setState({ username })
  }

  handlePasswordChange(e) {
    e.preventDefault()
    const password = e.target.value
    this.setState({ password })
  }

  handleFormSubmit(e) {
    e.preventDefault()

    this.setState({ isSubmitting: true })

    this.props
      .deleteUser({
        variables: {
          username: this.state.username,
          password: this.state.password,
        },
      })
      .then(response => {
        const { data, errors } = response

        if (errors && errors.length) {
          this.setState({ errors })
        } else {
          this.props.setCurrentUser(null)
        }
      })

      .catch(data => console.error(data))

      .finally(() => {
        this.setState({ isSubmitting: false })
      })
  }

  render() {
    const {
      first,
      user: { username },
    } = this.props

    const { username: usernameConfirm, password, isOpen, errors } = this.state

    const disabled = usernameConfirm !== username || !password

    const body = [
      <div className="card-content padding-bottom--none" key="content">
        <p className="margin-bottom--medium">
          If you are <strong>absolutely</strong> sure you want to do this, you
          can delete your account. THIS WILL REMOVE ALL YOUR CHARACTERS, and
          NOTHING will be recovered. Please be sure you have a backup of your
          art.
        </p>

        {errors.map((e, i) => (
          <div key={i} className="red-text margin-bottom--medium">
            {e.message}
          </div>
        ))}

        <Row className="no-margin">
          <Col s={12} m={6}>
            <div className="input-field">
              <input
                type="text"
                name="username"
                id="delete_username"
                autoComplete="false"
                value={usernameConfirm}
                onChange={this.handleUserChange}
                disabled={this.state.isSubmitting}
              />
              <label htmlFor="delete_username">Username Confirmation</label>
              {disabled && !usernameConfirm && (
                <span className="hint hint-block error error-text">
                  Please type your username to confirm delete.
                </span>
              )}
            </div>
          </Col>

          <Col s={12} m={6}>
            <div className="input-field">
              <input
                type="password"
                name="password"
                id="delete_password"
                autoComplete="current-password"
                value={password}
                onChange={this.handlePasswordChange}
                disabled={this.state.isSubmitting}
              />
              <label htmlFor="delete_password">Password Confirmation</label>
              {disabled && !password && (
                <span className="hint hint-block">
                  Please type your password to confirm delete.
                </span>
              )}
            </div>
          </Col>
        </Row>
      </div>,
      <div className="card-action right-align" key="action">
        <Button
          data-disable-with="Hang on..."
          className="red"
          type="submit"
          disabled={disabled || this.state.isSubmitting}
        >
          {this.state.isSubmitting
            ? 'Deleting everything...'
            : 'Delete Account'}
        </Button>
      </div>,
    ]

    return (
      <form
        className={c('card sp', { 'margin-top--large': !first })}
        method="POST"
        onSubmit={this.handleFormSubmit}
      >
        <div
          className="card-header"
          onClick={this.toggleOpen}
          style={{ cursor: 'pointer' }}
        >
          <h2 className="red-text">
            {this.state.isSubmitting ? 'Deleting Account...' : 'Delete Account'}
          </h2>
        </div>

        {isOpen && body}
      </form>
    )
  }
}

DeleteUser.propTypes = {
  first: PropTypes.bool,
  user: PropTypes.shape({
    username: PropTypes.string.isRequired,
  }),
  deleteUser: PropTypes.func.isRequired,
}

const DELETE_USER_MUTATION = gql`
  mutation DeleteUser($username: String!, $password: String!) {
    deleteUser(username: $username, password: $password) {
      username
      deleted_at
    }
  }
`

const Wrapped = props => (
  <Mutation mutation={DELETE_USER_MUTATION}>
    {(send, { mutationData }) => (
      <DeleteUser {...props} deleteUser={send} deleteResult={mutationData} />
    )}
  </Mutation>
)

export { DeleteUser }
export default compose(withRouter, withCurrentUser(true))(Wrapped)
