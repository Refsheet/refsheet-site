import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { withCurrentUser } from '../../../utils/compose'
import { H1 } from '../../Styled/Headings'
import { withNamespaces } from 'react-i18next'

class NewDiscussion extends Component {
  constructor(props) {
    super(props)

    this.state = { post: {} }
  }

  render() {
    const { forum, t } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <H1>New Discussion</H1>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

NewDiscussion.propTypes = {
  forum: PropTypes.object.isRequired,
}

export default compose(
  withNamespaces('common'),
  withCurrentUser()
)(NewDiscussion)
