/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Forums.Threads.List = React.createClass({
  propTypes: {
    threads: PropTypes.array,
    activeThreadId: PropTypes.string,
  },

  _nudgeClick(e) {
    const $el = $(e.target)
    $el
      .parents('li')
      .children('a')[0]
      .click()
    return e.preventDefault()
  },

  render() {
    const __this = this

    const sortedThreads = this.props.threads.sort(function(a, b) {
      switch (false) {
        case !(a.last_post_at > b.last_post_at):
          return -1
        case !(a.last_post_at < b.last_post_at):
          return 1
        default:
          return 0
      }
    })

    const threads = sortedThreads.map(thread => {
      const classNames = []
      if (thread.id === this.props.activeThreadId) {
        classNames.push('active')
      }
      if (thread.unread_posts_count) {
        classNames.push('unread')
      }

      return (
        <li
          className={classNames.join(' ')}
          key={thread.id}
          onClick={__this._nudgeClick}
        >
          <Link to={thread.path} className="truncate strong">
            {thread.topic}
          </Link>

          <div className="muted">
            By {thread.user_name} &bull; {thread.posts_count} replies
            {thread.unread_posts_count > 0 && (
              <span className="unread-count">
                {' '}
                ({thread.unread_posts_count} new)
              </span>
            )}
            {thread.last_post_at && (
              <div className="right muted">
                Last: <DateFormat timestamp={thread.last_post_at} short fuzzy />
              </div>
            )}
          </div>
        </li>
      )
    })

    return (
      <div className="thread-list">
        {/* All | Subscribed | Sort v */}
        <ul className="message-list margin--none">
          {threads.length == 0 && <EmptyList coffee />}

          {/* sticky */}
          {/* sponsored */}
          {threads}
        </ul>
      </div>
    )
  },
})
