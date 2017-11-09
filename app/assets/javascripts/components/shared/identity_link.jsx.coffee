@IdentityLink = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    to: React.PropTypes.shape
      link: React.PropTypes.string.isRequired
      name: React.PropTypes.string.isRequired
      username: React.PropTypes.string.isRequired
      type: React.PropTypes.string.isRequired

  timer: null

  getInitialState: ->
    user: null

  _load: ->
    $.get '/users/' + @props.to.username + '/follow.json', (user) =>
      @setState { user }

  _handleFollowClick: (e) ->
    action = if @state.user.followed then 'delete' else 'post'
    Model.request action, '/users/' + @props.to.username + '/follow.json', {}, (user) =>
      @setState { user }
    e.preventDefault()

  _handleLinkMouseover: ->
    @timer = setTimeout =>
      $(@refs.info).fadeIn()
      @_load()
    , 750

  _handleLinkMouseout: ->
    clearTimeout @timer

  _handleCardMouseover: ->
    clearTimeout @timer

  _handleCardMouseout: (e) ->
    @timer = setTimeout =>
      $(@refs.info).fadeOut()
    , 250

  render: ->
    { user } = @state
    { to } = @props

    if user
      { followed, follower } = user

      mutual = followed or follower
      followColor = if followed then '#ffca28' else 'rgba(255, 255, 255, 0.7)'
      isYou = to.username == @context.currentUser?.username
      canFollow = !!@context.currentUser and not isYou


    `<div className='identity-link-wrapper' style={{ position: 'relative', display: 'inline-block' }}>
        <div className='identity-card card with-avatar z-depth-2 sp'
             ref='info'
             onMouseOut={ this._handleCardMouseout }
             onMouseOver={ this._handleCardMouseover }
             style={{
                 position: 'absolute',
                 top: '0rem',
                 marginTop: '-1rem',
                 left: 'calc(-48px - 2rem)',
                 zIndex: '899',
                 minWidth: '300px',
                 backgroundColor: 'rgba(0, 0, 0, 0.9)',
                 display: 'none'
             }}
        >
            { this.props.to.avatarUrl &&
                <img src={ this.props.to.avatarUrl } alt={ this.props.to.name } className='avatar circle' /> }

            <div className='card-content'>
                { canFollow &&
                    <a href='#' className='secondary-content right' style={{ color: followColor }} onClick={ this._handleFollowClick }>
                        <Icon>person_add</Icon>
                    </a> }

                <Link to={ this.props.to.link } style={{ display: 'block' }}>{ this.props.to.name }</Link>

                { mutual &&
                    <div className='followback'
                         style={{
                             fontSize: '0.8rem',
                             color: 'rgba(255,255,255,0.7)',
                             textTransform: 'uppercase',
                             display: 'inline-block'
                         }}
                    >
                        { follower ? 'Follows ' + ( followed ? 'Back' : 'You' ) : 'Following' }
                    </div> }

                { isYou &&
                    <div className='followback'
                         style={{
                             fontSize: '0.8rem',
                             color: 'rgba(255,255,255,0.7)',
                             textTransform: 'uppercase',
                             display: 'inline-block'
                         }}
                    >
                        That's you!
                    </div> }

                { this.state.user &&
                    <ul className='stats stats-compact margin-bottom--none margin-top--medium'>
                        <li>
                            <div className='value'>{ NumberUtils.format(this.state.user.followers) }</div>
                            <div className='label'>Followers</div>
                        </li>
                        <li>
                            <div className='value'>{ NumberUtils.format(this.state.user.following) }</div>
                            <div className='label'>Following</div>
                        </li>
                    </ul> }

                { !this.state.user &&
                    <div className='grey-text'>Loading...</div> }
            </div>
        </div>

        <Link to={ this.props.to.link }
              onMouseOver={ this._handleLinkMouseover }
              onMouseOut={ this._handleLinkMouseout }
        >
            { this.props.to.name }
        </Link>
    </div>`
