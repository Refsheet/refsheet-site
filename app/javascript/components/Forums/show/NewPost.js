import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser } from '../../../utils/compose'

class NewPost extends Component {
  constructor(props) {
    super(props)

    this.state = { post: {} }
  }

  render() {
    const { forum } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <div className={'forum-post--content'}>{forum.about}</div>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

NewPost.propTypes = {}

export default compose(withCurrentUser())(NewPost)
