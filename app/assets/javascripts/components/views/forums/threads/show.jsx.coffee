@Forums.Threads.Show = v1 -> React.createClass
  contextTypes:
    currentUser: React.PropTypes.object
    eagerLoad: React.PropTypes.object

  propTypes:
    onReply: React.PropTypes.func

  dataPath: '/forums/:forumId/:threadId'

  poller: null

  paramMap:
    forumId: 'forum_id'
    threadId: 'id'

  getInitialState: ->
    thread: null

  componentWillMount: ->
    StateUtils.load @, 'thread', @props, (thread) =>
      @_poll() if thread
      console.log 'Starting poll.'

  componentWillUnmount: ->
    clearTimeout @poller
    console.log 'Stopping poll.'

  _poll: ->
    @poller = setTimeout =>
      Model.poll @state.thread.path, {}, (data) =>
        if data.id == @state.thread.id
          willScroll = @state.thread.posts.length < data.posts.length and (window.innerHeight + window.scrollY) >= document.body.offsetHeight

          @setState thread: data, =>
            window.scrollTo 0, document.getElementById('scroll-to-here').offsetTop if willScroll

        @_poll()
    , 3000

  componentWillReceiveProps: (newProps) ->
    StateUtils.reload @, 'thread', newProps

  _handleReply: (post) ->
    StateUtils.updateItem @, 'thread.posts', post, 'id', ->
      window.scrollTo 0, document.getElementById('scroll-to-here').offsetTop
    @props.onReply(post) if @props.onReply

  render: ->
    return `<Loading />` unless @state.thread

    posts = @state.thread.posts.map (post) ->
      `<div className='card sp with-avatar' key={ post.id }>
          <IdentityAvatar src={ post.user } avatarUrl={ post.character && (post.character.profile_image_url || (post.character.profile_image && post.character.profile_image.url.thumbnail)) } name={ post.character && post.character.name } />

          <div className='card-content'>
              <div className='muted right'>{ post.created_at_human }</div>
              <IdentityLink to={ post.user } name={ post.character && post.character.name } link={ post.character && post.character.link } avatarUrl={ post.character && (post.character.profile_image_url || (post.character.profile_image && post.character.profile_image.url.thumbnail)) } />
              <RichText className='margin-top--small' content={ post.content_html } markup={ post.content } />
          </div>
      </div>`

    `<Main title={ this.state.thread.topic }>
        <div className='card margin-top--none sp with-avatar'>
            <IdentityAvatar src={ this.state.thread.user } />

            <div className='card-content'>
                <div className='right muted right-align'>
                    { this.state.thread.created_at_human }
                </div>

                <div className='author'>
                    <IdentityLink to={ this.state.thread.user } />
                    <div className='muted'>@{ this.state.thread.user.username } { this.state.thread.user.is_admin && <span>&bull; Admin</span> }</div>
                </div>
            </div>

            <div className='card-header'>
                <h2 className='title'>{ this.state.thread.topic }</h2>
                <RichText markup={ this.state.thread.content } content={ this.state.thread.content_html } />
            </div>
        </div>

        { posts }

        <div id='scroll-to-here' />

        { this.context.currentUser &&
            <LegacyForumReply discussionId={ this.state.thread.guid }
                              onPost={ this._handleReply }
            /> }
    </Main>`
