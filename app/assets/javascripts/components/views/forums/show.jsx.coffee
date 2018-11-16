@Forums.Show = React.createClass
  contextTypes:
    eagerLoad: React.PropTypes.object

  dataPath: '/forums/:forumId'
  paramMap:
    forumId: 'slug'

  poller: null

  getInitialState: ->
    forum: null
    threadScope: 'recent'

  componentWillMount: ->
    StateUtils.load @, 'forum', @props, (forum) =>
      @_poll() if forum

  componentWillUnmount: ->
    clearTimeout @poller

  _poll: ->
    @poller = setTimeout =>
      Model.poll @state.forum.path, {}, (data) =>
        @setState forum: data if data.id == @state.forum.id
        @_poll()
    , 15000

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'forum', newProps

  _handleThreadReply: (post) ->
    [thread, i] = HashUtils.findItem @state.forum.threads, post.thread_id, 'id'
    thread.posts_count += 1
    StateUtils.updateItem @, 'forum.threads', thread, 'id'

  render: ->
    return `<Loading />` unless @state.forum
    console.log(this.props)

    childrenWithProps = React.Children.map this.props.children, (child) =>
      React.cloneElement child,
        onReply: @_handleThreadReply

    `<Main title={ this.state.forum.name } fadeEffect flex>
        <Jumbotron className='short'>
            <h1>{ this.state.forum.name }</h1>
            <p>{ this.state.forum.description }</p>
        </Jumbotron>

        <Container flex>
            <div className='sidebar sidebar-flex'>
                <Forums.Threads.List forumId={ this.props.match.params.forumId }
                                     threads={ this.state.forum.threads }
                                     activeThreadId={ this.props.match.params.threadId } />
            </div>

            <div className='content'>
                { childrenWithProps ||
                    <EmptyList caption='Select a thread to start chatting.' />
                }
            </div>
        </Container>

        <FixedActionButton icon='add' href='#new-thread-modal' tooltip='New Thread' />
        <Forums.Threads.Modal forumId={ this.state.forum.slug } />
    </Main>`
