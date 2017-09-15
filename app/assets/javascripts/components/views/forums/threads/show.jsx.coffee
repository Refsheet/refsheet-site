@Forums.Threads.Show = React.createClass
  contextTypes:
    eagerLoad: React.PropTypes.object

  dataPath: '/forums/:forumId/:threadId'

  paramMap:
    forumId: 'forum_id'
    threadId: 'id'

  getInitialState: ->
    thread: null

  componentDidMount: ->
    StateUtils.load @, 'thread'

  _handleReply: (post) ->
    StateUtils.updateItem @, 'thread.posts', post, 'id'

  render: ->
    return `<Loading />` unless @state.thread

    posts = @state.thread.posts.map (post) ->
      `<div className='card sp with-avatar' key={ post.id }>
          <img src={ post.user.avatar_url } className='circle avatar' />
          <div className='card-content'>
              <div className='muted right'>{ post.created_at_human }</div>
              <Link to={ post.user.link }>{ post.user.name }</Link> { post.user.is_admin && <span className='muted'>&bull; Admin</span> }
              <RichText className='margin-top--small' content={ post.content_html } markup={ post.content } />
          </div>
      </div>`

    `<Main title={ this.state.thread.topic }>
        <div className='card margin-top--none sp'>
            <div className='card-header padding-bottom--none'>
                <div className='right muted right-align'>
                    { this.state.thread.created_at_human }
                </div>

                <div className='author'>
                    <img src={ this.state.thread.user.avatar_url } className='circle avatar left' />
                    <Link to={ this.state.thread.user.link }>{ this.state.thread.user.name }</Link>
                    <div className='muted'>@{ this.state.thread.user.username } { this.state.thread.user.is_admin && <span>&bull; Admin</span> }</div>
                </div>
            </div>
            <div className='card-content'>
                <h2 className='title'>{ this.state.thread.topic }</h2>
                <RichText markup={ this.state.thread.content } content={ this.state.thread.content_html } />
            </div>
        </div>

        { posts }

        <Forums.Threads.Reply forumId={ this.props.params.forumId }
                              threadId={ this.props.params.threadId }
                              onPost={ this._handleReply }
        />
    </Main>`
