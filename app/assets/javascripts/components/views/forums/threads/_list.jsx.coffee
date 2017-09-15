@Forums.Threads.List = React.createClass
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
        when a.posts_count > b.posts_count then -1
        when a.posts_count < b.posts_count then 1
        else 0

    threads = sortedThreads.map (thread) =>
      classNames = []
      classNames.push 'active' if thread.id == @props.activeThreadId
      classNames.push 'unread' if thread.is_unread

      `<li className={ classNames.join(' ') } key={ thread.id } onClick={ __this._nudgeClick }>
          <Link to={ thread.path } className='truncate strong'>{ thread.topic }</Link>
          <div className='muted'>By { thread.user_name } &bull; { thread.posts_count } replies</div>
      </li>`

    `<ul className='message-list margin--none'>
        { threads.length == 0 &&
            <EmptyList coffee /> }

        { threads }
    </ul>`
