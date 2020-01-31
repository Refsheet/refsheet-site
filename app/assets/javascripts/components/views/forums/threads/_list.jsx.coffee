@Forums.Threads.List = v1 -> React.createClass
  propTypes:
    threads: React.PropTypes.array
    activeThreadId: React.PropTypes.string

  _nudgeClick: (e) ->
    $el = $(e.target)
    $el.parents('li').children('a')[0].click()
    e.preventDefault()

  render: ->
    __this = @

    sortedThreads = @props.threads.sort (a, b) ->
      switch
        when a.last_post_at > b.last_post_at then -1
        when a.last_post_at < b.last_post_at then 1
        else 0

    threads = sortedThreads.map (thread) =>
      classNames = []
      classNames.push 'active' if thread.id == @props.activeThreadId
      classNames.push 'unread' if thread.unread_posts_count

      `<li className={ classNames.join(' ') } key={ thread.id } onClick={ __this._nudgeClick }>
          <Link to={ thread.path } className='truncate strong'>{ thread.topic }</Link>

          <div className='muted'>
              By { thread.user_name } &bull; { thread.posts_count } replies

              { thread.unread_posts_count > 0 &&
                  <span className='unread-count'> ({ thread.unread_posts_count } new)</span> }

              { thread.last_post_at &&
                  <div className='right muted'>
                      Last: <DateFormat timestamp={ thread.last_post_at } short fuzzy />
                  </div> }
          </div>
      </li>`

    `<div className='thread-list'>
        {/* All | Subscribed | Sort v */}
        <ul className='message-list margin--none'>
            { threads.length == 0 &&
                <EmptyList coffee /> }

            {/* sticky */}
            {/* sponsored */}
            { threads }
        </ul>
    </div>`
