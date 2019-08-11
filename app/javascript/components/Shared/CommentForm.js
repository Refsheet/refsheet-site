import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {connect} from "react-redux";
import IdentitySelect from "./CommentForm/IdentitySelect";
import UserAvatar from "../User/UserAvatar";
import IdentityModal from "./CommentForm/IdentityModal";
import Restrict from "./Restrict";
import MarkdownEditor from "./MarkdownEditor";

class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: "",
      error: "",
      identityModalOpen: false,
      submitting: false
    }
  }

  handleCommentChange(name, comment) {
    this.setState({ comment })
  }

  handleIdentityOpen() {
    this.setState({identityModalOpen: true})
  }

  handleIdentityClose() {
    this.setState({identityModalOpen: false})
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
      identity: this.props.identity
    })
      .then((data) => {
        if (data.errors) {
          this.handleError(data.errors[0])
        } else {
          this.setState({comment: "", submitting: false, error: ""})

          if (this.props.onSubmitConfirm) {
            this.props.onSubmitConfirm(data.data)
          }
        }
      })
      .catch(this.handleError)
  }

  render() {
    const {
      inCharacter,
      identity,
      richText
    } = this.props

    const placeholder = (this.props.placeholder || "").replace(/%n/, identity.name)

    return (
      <div className={'comment-form'}>
        <form className='card reply-box margin-top--none sp with-avatar'
              onSubmit={ this.handleSubmit.bind(this) }
        >
          <UserAvatar user={this.props.currentUser} identity={identity} />

          <div className='card-content reply-box'>
            { richText || <Input
              type={'textarea'}
              name='comment'
              browserDefault
              noMargin
              disabled={ this.state.submitting }
              placeholder={ placeholder }
              value={this.state.comment}
              onChange={this.handleCommentChange.bind(this)}
            /> }

            { richText && <MarkdownEditor
              name={'comment'}
              disabled={this.state.submitting}
              placeholder={ placeholder }
              content={this.state.comment}
              onChange={this.handleCommentChange.bind(this)}
            /> }

            { this.state.error && <span className={'error red-text smaller'}>{ this.state.error }</span> }

            <Row noMargin>
              <Column s={8}>
                <Restrict patron>
                  { inCharacter && <IdentitySelect onClick={this.handleIdentityOpen.bind(this)} name={identity.name} /> }
                </Restrict>
              </Column>
              <Column s={4}>
                <button type={'submit'} className='btn right' disabled={!this.state.comment || this.state.submitting}>
                  { this.state.submitting ? this.props.buttonSubmittingText : this.props.buttonText }
                </button>
              </Column>
            </Row>
          </div>
        </form>

        { this.state.identityModalOpen && <IdentityModal onClose={this.handleIdentityClose.bind(this)} /> }
      </div>
    )
  }
}

CommentForm.propTypes = {
  inCharacter: PropTypes.bool,
  richText: PropTypes.bool,
  onSubmit: PropTypes.func.isRequired,
  onSubmitConfirm: PropTypes.func,
  placeholder: PropTypes.string,
  value: PropTypes.string,
  buttonText: PropTypes.string,
  buttonSubmittingText: PropTypes.string
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
  identity: state.session.identity
})

export default connect(mapStateToProps)(CommentForm)