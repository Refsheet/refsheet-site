import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Main from '../../Shared/Main'
import Header from './Header'
import TabbedContent from '../../Shared/TabbedContent'
import DiscussionLink from '../../Forums/show/DiscussionLink'

import Advertisement from 'v1/shared/advertisement'

class View extends Component {
  render() {
    const {
      artist: { name, avatar_url, profile, profile_markdown, user = {} },
    } = this.props

    return (
      <Main title={['Artist', name]}>
        <Header
          name={name}
          avatarUrl={avatar_url}
          username={user && user.username}
          profile={profile}
          profileMarkdown={profile_markdown}
        />

        <TabbedContent />

        <div className={'container container-flex'}>
          <main className={'content-left'}>
            {/*<div className={'forum-sort margin-bottom--medium'} />*/}

            {/*<pre>{JSON.stringify(this.props, undefined, 2)}</pre>*/}
          </main>

          <aside className={'sidebar left-pad'}>
            {typeof Advertisement != 'undefined' && <Advertisement />}
          </aside>
        </div>
      </Main>
    )
  }
}

View.propTypes = {
  artist: PropTypes.shape({
    name: PropTypes.string.isRequired,
  }),
}

export default View
