import React, { Component } from 'react'
import compose from '../../../utils/compose'

class View extends Component {
  render() {
    const { discussion } = this.props

    console.log({ discussion })

    return (
      <div className={'container container-flex'}>
        <main className={'content-left'}>
          <h1>{discussion.topic}</h1>
          <div className={'forum-post--content'}>{discussion.content}</div>
        </main>

        <aside className={'sidebar left-pad'}>
          {typeof Advertisement != 'undefined' && <Advertisement />}
        </aside>
      </div>
    )
  }
}

export default compose()(View)
