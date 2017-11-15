@Views.User.Follow = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    username: React.PropTypes.string.isRequired
    followed: React.PropTypes.bool
    onFollow: React.PropTypes.func
    short: React.PropTypes.bool

  _handleFollowClick: (e) ->
    action = if @props.followed then 'delete' else 'post'
    Model.request action, '/users/' + @props.username + '/follow.json', {}, (user) =>
      @props.onFollow user.followed, @props.username, user if @props.onFollow
    e.preventDefault()

  render: ->
    if @context.currentUser and @props.username != @context.currentUser.username
      followColor = if @props.followed then '#ffca28' else 'rgba(255, 255, 255, 0.7)'

      `<a href='#' className='secondary-content btn btn-flat right cs--secondary-color' style={{ border: '1px solid rgba(255,255,255,0.1)' }} onClick={ this._handleFollowClick }>
          { !this.props.short &&
              <span className='hide-on-med-and-down cs--secondary-color' style={{ marginRight: '1rem' }}>{ this.props.followed ? 'Following' : 'Follow' }</span> }

          <Icon style={{ color: followColor, marginLeft: '0' }} className='right'>person_add</Icon>
      </a>`

    else
      null
