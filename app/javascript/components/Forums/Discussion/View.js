import React, { Component } from 'react'
import compose from '../../../utils/compose'
import Jumbotron from '../../Shared/Jumbotron'
import Main from '../../Shared/Main'
import { Link } from 'react-router-dom'

class View extends Component {
  render() {
    const { discussion } = this.props

    console.log({ discussion })

    return (
      <Main title={'Forums'} className={'main-flex split-bg-right'}>
        <Jumbotron short>
          <h1>{discussion.topic}</h1>
          <p>
            Posted in:{' '}
            <Link to={`/v2/forums/${discussion.forum.slug}`}>
              {discussion.forum.name}
            </Link>
          </p>
        </Jumbotron>

        <div className={'container container-flex'}>
          <main className={'content-left'}>
            <div className={'forum-post--content'}>{discussion.content}</div>
          </main>

          <aside className={'sidebar left-pad'}>
            {typeof Advertisement != 'undefined' && <Advertisement />}
          </aside>
        </div>
      </Main>
    )
  }
}

export default compose()(View)
