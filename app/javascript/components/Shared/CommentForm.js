import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import IdentitySelect from './CommentForm/IdentitySelect'
import UserAvatar from '../User/UserAvatar'
import IdentityModal from './CommentForm/IdentityModal'
import Restrict from './Restrict'
import MarkdownEditor from './MarkdownEditor'
import { Row, Col, Button } from 'react-materialize'
import compose from 'utils/compose'
import { withTranslation } from 'react-i18next'
import WindowAlert from 'utils/WindowAlert'
import { div as Card } from '../Styled/Card'
import c from 'classnames'
import Icon from 'v1/shared/material/Icon'
import Input from 'v1/shared/forms/Input'
import * as Materialize from 'materialize-css'
import { createIdentity } from '../../utils/IdentityUtils'

// TODO: This class has now 3 different styles that it produces,
//       this should be refactored into a generic wrapper that handles
//       functionality and passes components to a child class to render
//       those specific variants.
//       THIS IS BECOMING A WHOLE-ASS CRISIS
//
// Known Variants:
//   - default (V1 Forums, Status Updates)
//   - slim    (Lightbox Comment Form, Messages?)
//   - v2Style (V2 Forums)
//
class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: this.props.value,
      error: '',
      identityModalOpen: false,
      submitting: false,
    }
  }

  getDraftKey() {
    return this.props.draftKey || 'comment-' + this.props.name
  }

  handleCommentChange(name, comment) {
    this.setState({ comment })

    if (comment !== this.props.value) {
      WindowAlert.dirty(this.getDraftKey(), 'You have a pending comment.')
    } else {
      WindowAlert.clean(this.getDraftKey())
    }
  }

  handleCancel(e) {
    e.preventDefault()

    const { draftKey = 'comment-' + name, onCancel } = this.props

    WindowAlert.clean(this.getDraftKey())
    onCancel && onCancel()
  }

  handleIdentityOpen() {
    this.setState({ identityModalOpen: true })
  }

  handleIdentityClose() {
    this.setState({ identityModalOpen: false })
  }

  handleError(error) {
    console.error(error)
    let message = ''

    if (error.map) {
      message = error.map(e => e.message).join(', ')
    } else {
      message = error.message || '' + error
    }

    this.setState({ submitting: false, error: message })
  }

  handleSubmit(e) {
    e.preventDefault()

    const { draftKey = 'comment-' + name } = this.props

    this.setState({ submitting: true })

    if (!this.state.comment) {
      Materialize.toast({
        html: 'Please enter a comment!',
        displayLength: 3000,
        classes: 'red',
      })
    }

    this.props
      .onSubmit({
        comment: this.state.comment,
        identity: this.props.identity,
      })
      .then(data => {
        if (data && data.errors) {
          this.handleError(data.errors[0])
        } else {
          this.setState({ comment: '', submitting: false, error: '' })
          WindowAlert.clean(this.getDraftKey())

          if (this.props.onSubmitConfirm) {
            this.props.onSubmitConfirm(data.data || data)
          }
        }
      })
      .catch(this.handleError.bind(this))
  }

  render() {
    const {
      inCharacter = false,
      richText,
      slim = false,
      emoji,
      hashtags,
      onCancel,
      children,
      t,
    } = this.props

    const identity = createIdentity({
      user: this.props.currentUser,
      identity: this.props.identity,
    })

    const placeholder = (this.props.placeholder || '').replace(
      /%n/,
      identity.name
    )

    let submitButton, input

    if (slim) {
      submitButton = (
        <div className={'send'}>
          <Button
            type={'submit'}
            className={'btn right flat'}
            disabled={!this.state.comment || this.state.submitting}
          >
            {this.state.submitting ? (
              <Icon title={this.props.buttonSubmittingText}>
                hourglass_empty
              </Icon>
            ) : (
              <Icon title={this.props.buttonText}>send</Icon>
            )}
          </Button>
        </div>
      )

      input = (
        <Input
          type={'textarea'}
          name={'comment'}
          browserDefault
          autoGrow
          noMargin
          disabled={this.state.submitting}
          placeholder={placeholder}
          value={this.state.comment}
          onChange={this.handleCommentChange.bind(this)}
        />
      )
    } else {
      submitButton = (
        <Row className={'no-margin'}>
          <Col s={8}>
            {onCancel && (
              <Button
                type={'cancel'}
                onClick={this.handleCancel.bind(this)}
                className={'btn btn-secondary left margin-right--small'}
                disabled={this.state.submitting}
              >
                {this.props.cancelText || t('actions.cancel', 'Cancel')}
              </Button>
            )}

            {inCharacter && (
              <IdentitySelect
                onClick={this.handleIdentityOpen.bind(this)}
                name={identity.name}
              />
            )}
          </Col>
          <Col s={4}>
            <Button
              type={'submit'}
              onClick={this.handleSubmit.bind(this)}
              className="btn right"
              disabled={!this.state.comment || this.state.submitting}
            >
              {this.state.submitting
                ? this.props.buttonSubmittingText
                : this.props.buttonText}
            </Button>
          </Col>
        </Row>
      )

      if (richText) {
        input = (
          <MarkdownEditor
            name={'comment'}
            readOnly={this.state.submitting}
            placeholder={placeholder}
            content={this.state.comment}
            emoji={emoji}
            hashtags={hashtags}
            onChange={this.handleCommentChange.bind(this)}
          />
        )
      } else {
        input = (
          <Input
            type={'textarea'}
            name="comment"
            browserDefault
            noMargin
            disabled={this.state.submitting}
            placeholder={placeholder}
            value={this.state.comment}
            onChange={this.handleCommentChange.bind(this)}
          />
        )
      }
    }

    if (this.props.v2Style) {
      return (
        <form
          className={'v2-reply-box'}
          onSubmit={this.handleSubmit.bind(this)}
        >
          <UserAvatar
            user={this.props.currentUser}
            identity={identity}
            onIdentityChangeClick={this.handleIdentityOpen.bind(this)}
          />

          <Card className={'reply-content card sp'}>
            {children}

            <div className={'reply-content card-content padding--none'}>
              {input}
            </div>

            {this.state.error && (
              <div className={'error card-footer red-text smaller'}>
                {this.state.error}
              </div>
            )}

            <div className={'card-footer'}>{submitButton}</div>

            {this.state.identityModalOpen && (
              <IdentityModal onClose={this.handleIdentityClose.bind(this)} />
            )}
          </Card>
        </form>
      )
    }

    return (
      <Card className={'comment-form'}>
        <form
          className={c('card reply-box margin-top--none sp with-avatar')}
          onSubmit={this.handleSubmit.bind(this)}
        >
          <Card className={c('card reply-box margin-top--none sp with-avatar')}>
            <UserAvatar
              user={this.props.currentUser}
              identity={identity}
              onIdentityChangeClick={this.handleIdentityOpen.bind(this)}
            />

            <div className="card-content reply-box">
              {children}
              {input}
              {this.state.error && (
                <span className={'error red-text smaller'}>
                  {this.state.error}
                </span>
              )}
              {submitButton}
            </div>
          </Card>
        </form>

        {this.state.identityModalOpen && (
          <IdentityModal onClose={this.handleIdentityClose.bind(this)} />
        )}
      </Card>
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
  buttonSubmittingText: PropTypes.string,
  slim: PropTypes.bool,
  hashtags: PropTypes.bool,
  emoji: PropTypes.bool,
}

const mapStateToProps = (state, props) => ({
  ...props,
  currentUser: state.session.currentUser,
  identity: state.session.identity,
})

export default compose(
  connect(mapStateToProps),
  withTranslation('common')
)(CommentForm)
