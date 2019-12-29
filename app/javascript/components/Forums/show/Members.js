import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'

class Members extends Component {
  constructor(props) {
    super(props)

    this.state = { page: 1, sort: 'default' }
  }

  render() {
    const { forum } = this.props

    return (
      <div className={'container container-flex'}>
        <main className={'content-left'}>
          <div className={'forum-post--content'}>{forum.about}</div>
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
