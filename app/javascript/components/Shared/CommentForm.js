import React, { Component } from 'react'
import PropTypes from 'react'
import {connect} from "react-redux";
import IdentitySelect from "./CommentForm/IdentitySelect";
import UserAvatar from "../User/UserAvatar";

class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: "",
      error: "",
      identity: {}
    }
  }

  handleCommentChange(e) {
    this.setState({comment: e.target.value})
  }

  handleSubmit(e) {
    e.preventDefault()

    if (!this.state.comment) {
      M.toast("Please enter a comment!", { duration: 3000 })
    }

    this.props.onSubmit({
      comment: this.state.comment,
      identity: this.state.identity
    })
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
          <textarea
            name='comment'
            className='browser-default no-margin'
            placeholder={ placeholder }
            value={this.state.comment}
            onChange={this.handleCommentChange.bind(this)}
          />

          { this.state.error && <span className={'error red-text smaller'}>{ this.state.error }</span> }

          <Row noMargin>
            <Column s={8}>
              { inCharacter && <IdentitySelect /> }
            </Column>
            <Column s={4}>
              <button type={'submit'} className='btn right' disabled={!this.state.comment}>{ this.props.buttonText }</button>
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