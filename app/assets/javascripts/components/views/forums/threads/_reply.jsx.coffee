@Forums.Threads.Reply = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    forumId: React.PropTypes.string.isRequired
    threadId: React.PropTypes.string.isRequired
    onPost: React.PropTypes.func

  getInitialState: ->
    post:
      content: null

  _handlePost: (post) ->
    @props.onPost(post) if @props.onPost

  render: ->
    return null unless @context.currentUser

    `<Form className='card sp with-avatar reply-box'
           action={ '/forums/' + this.props.forumId + '/threads/' + this.props.threadId + '/posts' }
           method='POST'
           model={ this.state.post }
           modelName='post'
           onChange={ this._handlePost }
           resetOnSubmit
    >
        <IdentityAvatar src={ this.context.currentUser } />

        <div className='card-content'>
            <Input type='textarea' browserDefault name='content' placeholder='Leave a reply...' />

            <div className='right-align'>
                <Submit>Reply</Submit>
            </div>
        </div>
    </Form>`
