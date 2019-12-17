import React, { Component } from 'react'
import compose, { withCurrentUser, withMutations } from '../../utils/compose'
import { withNamespaces } from 'react-i18next'
import addComment from './addComment.graphql'

class CommentForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      comment: '',
    }
  }

  handleSubmit(e) {
    e.preventDefault()
    this.setState({ comment: '' })
  }

  render() {
    /*
    <Form className='reply-box'
              action={ '/media/' + this.props.mediaId + '/comments' }
              model={ {} }
              modelName='comment'
              onChange={ this._handleComment }
              resetOnSubmit
        >
          <Input type='textarea' name='comment' placeholder='Leave a comment...' noMargin browserDefault className='min-height overline block' />
          <Submit className='btn-square btn-block'>Send Comment <Icon className='right'>send</Icon></Submit>
        </Form>
     */
    return (
      <form>
        <input type={'textarea'} name={'comment'} placeholder={t('')} />
      </form>
    )
  }
}

export default compose(
  withMutations({ addComment }),
  withNamespaces('common'),
  withCurrentUser()
)(CommentForm)
