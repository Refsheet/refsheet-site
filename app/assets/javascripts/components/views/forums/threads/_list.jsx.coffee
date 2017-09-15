@Forums.Threads.List = React.createClass
  render: ->
    threads = [1..10].map (thread) ->
      classNames = []
      classNames.push 'active' if thread == 5
      classNames.push 'unread' if thread % 4 == 0 or thread % 5 == 0

      `<li className={ classNames.join(' ') } key={ thread }>
          <Link to='/forums/support/update-9324' className='truncate strong'>The November update is here!</Link>
          <div className='muted'>By Mau Abata &bull; 932 replies</div>
      </li>`

    threads = []

    `<ul className='message-list margin--none'>
        { threads.length == 0 &&
            <EmptyList coffee /> }

        { threads }
    </ul>`
