import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'

import Advertisement from 'v1/shared/advertisement'

class Members extends Component {
  constructor(props) {
    super(props)

    this.state = { page: 1, sort: 'default' }
  }

  render() {
    const { forum } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left padding-bottom--large'}>
          <div className={'forum-post--content'}>
            <p className={'caption'}>
              This is a system group, everyone is a member.
            </p>
          </div>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

Members.propTypes = {}

export default compose()(Members)
// TODO: Add HOC bindings here
