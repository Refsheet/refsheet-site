import React, { Component } from 'react'
import PropTypes from 'react'
import {connect} from "react-redux";
import IdentitySelect from "./CommentForm/IdentitySelect";
import UserAvatar from "../User/UserAvatar";
import Restrict from "./Restrict";

class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: "",
      error: "",
      submitting: false,
      identity: {}
    }
  }

  handleCommentChange(name, value) {
    this.setState({ comment: value })
  }

  handleError(error) {
    console.error(error)
    let message = ""

    if (error.map) {
      message = error.map((e) => e.message).join(", ")
    } else {
      message = error.message || ("" + error)
    }

    this.setState({ submitting: false, error: message })
  }

  handleSubmit(e) {
    e.preventDefault()
    this.setState({ submitting: true })

    if (!this.state.comment) {
      M.toast("Please enter a comment!", { duration: 3000 })
    }

    this.props.onSubmit({
      comment: this.state.comment,
      identity: this.state.identity
    })
      .then((data) => {
        if (data.errors) {
          this.handleError(data.errors[0])
        } else {
          this.setState({comment: "", submitting: false, error: ""})
        }
      })
      .catch(this.handleError)
  }

  render() {
    const {
      inCharacter
    } = this.props

    const identity = {
      name: this.props.currentUser.name,
      avatarUrl: this.props.currentUser.avatar_url
    }

    const placeholder = (this.props.placeholder || "").replace(/%n/, identity.name)

    return (
      <form className='card reply-box margin-top--none sp with-avatar'
            onSubmit={ this.handleSubmit.bind(this) }
      >
        <UserAvatar user={this.props.currentUser} />

        <div className='card-content reply-box'>
          <Input
            type={'textarea'}
            name='comment'
            browserDefault
            noMargin
            disabled={ this.state.submitting }
            placeholder={ placeholder }
            value={this.state.comment}
            onChange={this.handleCommentChange.bind(this)}
          />

          { this.state.error && <span className={'error red-text smaller'}>{ this.state.error }</span> }

          <Row noMargin>
            <Column s={8}>
              <Restrict admin>
                { inCharacter && <IdentitySelect /> }
              </Restrict>
            </Column>
            <Column s={4}>
              <button type={'submit'} className='btn right' disabled={!this.state.comment || this.state.submitting}>
                { this.state.submitting ? "Posting..." : this.props.buttonText }
              </button>
            </Column>
          </Row>
        </div>
      </form>
    )
  }
}

CommentForm.propTypes = {
  inCharacter: PropTypes.boolean,
  richText: PropTypes.boolean,
  onSubmit: PropTypes.func,
  placeholder: PropTypes.string,
  value: PropTypes.string,
  buttonText: PropTypes.string
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
})

export default connect(mapStateToProps)(CommentForm)