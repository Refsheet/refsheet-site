import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import KarmaButton from './KarmaButton'
import c from 'classnames'

class KarmaCounter extends Component {
  constructor(props) {
    super(props)

    this.state = { loading: false }
  }

  onKarmaLoad(value) {
    this.setState({ loading: value })
  }

  render() {
    const { discussion, forum, className } = this.props

    return (
      <div className={c('forum-post--votes', className)}>
        <div className="forum-post--upvote">
          <KarmaButton
            give
            postId={discussion.id}
            forumId={forum.slug}
            onLoading={this.onKarmaLoad.bind(this)}
            disabled={false}
            voted={false}
          />
        </div>

        <div className={'forum-post--karma'}>
          {this.state.loading ? '...' : discussion.karma_total || 0}
        </div>

        <div className="forum-post--downvote">
          <KarmaButton
            take
            postId={discussion.id}
            forumId={forum.slug}
            onLoading={this.onKarmaLoad.bind(this)}
            disabled={false}
            voted={false}
          />
        </div>
      </div>
    )
  }
}

KarmaCounter.propTypes = {
  discussion: PropTypes.object.isRequired,
  forum: PropTypes.object.isRequired,
}

export default compose()(KarmaCounter)
// TODO: Add HOC bindings here
