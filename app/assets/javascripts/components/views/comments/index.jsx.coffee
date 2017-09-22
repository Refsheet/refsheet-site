@Comments = {}

@Comments.Index = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    mediaId: React.PropTypes.string.isRequired
    comments: React.PropTypes.array
    poll: React.PropTypes.bool
    onCommentChange: React.PropTypes.func

  getInitialState: ->
    model:
      comment: ''

  _poll: ->
    @poller = setTimeout =>
      Model.poll "/media/#{@props.mediaId}/comments", {}, (data) =>
        data.map (comment) =>
          @props.onCommentChange comment if @props.onCommentChange
        @_poll()
    , 3000

  componentDidMount: ->
    @_poll() if @props.onCommentChange and @props.poll

  componentWillUnmount: ->
    clearTimeout @poller

  _handleComment: (comment) ->
    @props.onCommentChange comment if @props.onCommentChange

  render: ->
    comments = @props.comments.map (comment) ->
      `<div className='card flat with-avatar' key={ comment.id }>
          <img src={ comment.user.avatar_url } className='circle avatar' />
          <div className='card-content'>
              <div className='muted right'>{ comment.created_at_human }</div>
              <Link to={ comment.user.link }>{ comment.user.name }</Link>
              <RichText content={ comment.comment } markup={ comment.comment } />
          </div>
      </div>`

    `<div className='flex-vertical'>
        <div className='flex-content overflow' ref='commentBox'>
            { comments.reverse() }
            { comments.length <= 0 &&
                <p className='caption padding--medium'>No comments yet!</p> }
        </div>

        <div className='flex-fixed'>
            <Form className='reply-box'
                  action={ '/media/' + this.props.mediaId + '/comments' }
                  model={ this.state.model }
                  modelName='comment'
                  onChange={ this._handleComment }
                  resetOnSubmit
            >
                <Input type='textarea' name='comment' placeholder='Leave a comment...' noMargin browserDefault className='min-height overline block' />
                <Submit className='btn-square btn-block'>Send Comment <Icon className='right'>send</Icon></Submit>
            </Form>
        </div>
    </div>`
