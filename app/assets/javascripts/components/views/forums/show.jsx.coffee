@Forums.Show = React.createClass
  dataPath: '/forums/:forumId'
  paramMap:
    forumId: 'slug'

  getInitialState: ->
    forum: null
    threadScope: 'recent'

  componentWillMount: ->
    StateUtils.load @, 'forum'

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'forum', newProps


  render: ->
    return `<Loading />` unless @state.forum

    `<Main title={ this.state.forum.name } fadeEffect flex>
        <Jumbotron className='short'>
            <h1>{ this.state.forum.name }</h1>
            <p>{ this.state.forum.description }</p>
        </Jumbotron>

        <Container flex>
            <div className='sidebar sidebar-flex'>
                <Forums.Threads.List forumId={ this.state.forum.slug } />
            </div>

            <div className='content'>
                { this.props.children ||
                    <EmptyList caption='Select a thread to start chatting.' />
                }
            </div>
        </Container>

        <FixedActionButton icon='add' href='#new-thread-modal' tooltip='New Thread' />
        <Forums.Threads.Modal forumId={ this.state.forum.slug } />
    </Main>`
