import React, { Component } from 'react'
import PropTypes from 'prop-types'
import {connect} from "react-redux";
import IdentitySelect from "./CommentForm/IdentitySelect";
import UserAvatar from "../User/UserAvatar";
import IdentityModal from "./CommentForm/IdentityModal";

class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: "",
      error: "",
      identityModalOpen: false,
      submitting: false,
      character: null
    }
  }

  handleCommentChange(name, comment) {
    this.setState({ comment })
  }

  handleCharacterChange(character) {
    this.setState({character, identityModalOpen: false})
  }

  handleIdentityOpen() {
    this.setState({identityModalOpen: true})
  }

  handleIdentityClose() {
    this.setState({identityModalClosed: false})
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

  getIdentity() {
    if (this.state.character) {
      return {
        name: this.state.character.name,
        avatarUrl: this.state.character.profile_image.url.thumbnail,
        characterId: this.state.character.id
      }
    } else {
      return {
        name: this.props.currentUser.name,
        avatarUrl: this.props.currentUser.avatar_url,
        characterId: null
      }
    }
  }

  handleSubmit(e) {
    e.preventDefault()
    this.setState({ submitting: true })

    if (!this.state.comment) {
      M.toast("Please enter a comment!", { duration: 3000 })
    }

    this.props.onSubmit({
      comment: this.state.comment,
      identity: this.getIdentity()
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

    const identity = this.getIdentity()

    const placeholder = (this.props.placeholder || "").replace(/%n/, identity.name)

    return (
      <div className={'comment-form'}>
        <form className='card reply-box margin-top--none sp with-avatar'
              onSubmit={ this.handleSubmit.bind(this) }
        >
          <UserAvatar user={this.props.currentUser} identity={identity} />

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
                { inCharacter && <IdentitySelect onClick={this.handleIdentityOpen.bind(this)} name={identity.name} /> }
              </Column>
              <Column s={4}>
                <button type={'submit'} className='btn right' disabled={!this.state.comment || this.state.submitting}>
                  { this.state.submitting ? this.props.buttonSubmittingText : this.props.buttonText }
                </button>
              </Column>
            </Row>
          </div>
        </form>

        { this.state.identityModalOpen && <IdentityModal onCharacterSelect={this.handleCharacterChange.bind(this)} onClose={this.handleIdentityClose.bind(this)} /> }
      </div>
    )
  }
}

CommentForm.propTypes = {
  inCharacter: PropTypes.bool,
  richText: PropTypes.bool,
  onSubmit: PropTypes.func,
  placeholder: PropTypes.string,
  value: PropTypes.string,
  buttonText: PropTypes.string,
  buttonSubmittingText: PropTypes.string
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
})

export default connect(mapStateToProps)(CommentForm)