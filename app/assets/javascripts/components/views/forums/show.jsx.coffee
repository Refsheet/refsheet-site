@Forums.Show = React.createClass
  dataPath: '/forums/:forumId'
  paramMap:
    forumId: 'slug'

  getInitialState: ->
    forum: null

  componentWillMount: ->
    StateUtils.load @, 'forum'

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'forum', newProps


  render: ->
    return null unless @state.forum

    threads = [1..10].map (thread) ->
      classNames = []
      classNames.push 'active' if thread == 5

      `<li className={ classNames.join(' ') } key={ thread }>
          <Link to='/forums/support/update-9324' className='truncate strong'>The November update is here!</Link>
          <div className='muted'>By Mau Abata &bull; 932 replies</div>
      </li>`

    `<Main title={ this.state.forum.name } fadeEffect flex>
        <Jumbotron>
            <h1>{ this.state.forum.name }</h1>
            <p className='flow-text'>{ this.state.forum.description }</p>
        </Jumbotron>

        <Container flex>
            <ul className='message-list sidebar'>
                { threads }
            </ul>

            <div className='content'>
                { this.props.children ||
                    <p className='caption center'>Forum Topics will go here soon :3</p>
                }
            </div>
        </Container>
    </Main>`
