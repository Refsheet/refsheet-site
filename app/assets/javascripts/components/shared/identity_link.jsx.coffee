@IdentityLink = v1 -> React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    to: React.PropTypes.shape
      link: React.PropTypes.string.isRequired
      name: React.PropTypes.string.isRequired
      username: React.PropTypes.string.isRequired
      type: React.PropTypes.string
      avatar_url: React.PropTypes.string
    name: React.PropTypes.string
    link: React.PropTypes.string
    avatarUrl: React.PropTypes.string

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
    to = StringUtils.indifferentKeys @props.to

    if @props.avatarUrl
      to.type ||= 'character'
    else
      to.type ||= 'user'

    if to.is_admin || user?.is_admin
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'

    else if to.is_patron || user?.is_patron
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'

    if user
      { followed, follower } = user

      mutual = followed or follower
      followColor = if followed then '#ffca28' else 'rgba(255, 255, 255, 0.7)'
      isYou = to.username == @context.currentUser?.username
      canFollow = !!@context.currentUser and not isYou

      if to.type == 'character'
        byline = `<div className='byline' style={{ lineHeight: '1rem', marginBottom: '2px', marginTop: '3px' }}>By: <Link to={ '/' + to.username }>{ user.name }</Link></div>`


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
                 backgroundColor: 'rgba(26, 26, 26, 1)',
                 display: 'none'
             }}
        >
            { (to.avatarUrl || this.props.avatarUrl) &&
                <img src={ this.props.avatarUrl || to.avatarUrl } alt={ this.props.name || to.name } className='avatar circle' style={{ boxShadow: imgShadow }} height={48} width={48} /> }

            <div className='card-content'>
                { canFollow &&
                    <a href='#' className='secondary-content right' style={{ color: followColor, display: 'block' }} onClick={ this._handleFollowClick }>
                        <Icon>person_add</Icon>
                    </a> }

                <Link to={ this.props.link || to.link } style={{ display: 'block', whiteSpace: 'nowrap', marginRight: '3rem', color: nameColor }}>{ this.props.name || to.name }</Link>

                <div className='smaller' style={{ lineHeight: '1rem', verticalAlign: 'middle' }}>
                    { byline }

                    <span style={{ color: 'rgba(255,255,255,0.6)' }}>@{ to.username }</span>

                    { mutual &&
                        <span className='followback'
                              style={{
                                  fontSize: '0.6rem',
                                  lineHeight: '1rem',
                                  verticalAlign: 'middle',
                                  padding: '0 5px',
                                  borderRadius: '3px',
                                  backgroundColor: 'rgba(255,255,255, 0.05)',
                                  marginLeft: '0.5rem',
                                  color: 'rgba(255,255,255,0.6)',
                                  textTransform: 'uppercase',
                                  display: 'inline-block'
                              }}
                        >
                            { follower ? 'Follows ' + ( followed ? 'Back' : 'You' ) : 'Following' }
                        </span> }

                    { isYou &&
                        <span className='followback'
                              style={{
                                  fontSize: '0.6rem',
                                  lineHeight: '1rem',
                                  verticalAlign: 'middle',
                                  padding: '0 5px',
                                  borderRadius: '3px',
                                  backgroundColor: 'rgba(255,255,255, 0.05)',
                                  marginLeft: '0.5rem',
                                  color: 'rgba(255,255,255,0.6)',
                                  textTransform: 'uppercase',
                                  display: 'inline-block'
                              }}
                        >
                            That's you!
                        </span> }
                </div>

                { user &&
                    <ul className='stats stats-compact margin-bottom--none margin-top--medium'>
                        <li>
                            <div className='value'>{ NumberUtils.format(user.followers) }</div>
                            <div className='label'>Followers</div>
                        </li>
                        <li>
                            <div className='value'>{ NumberUtils.format(user.following) }</div>
                            <div className='label'>Following</div>
                        </li>
                    </ul> }

                { !user &&
                    <div className='grey-text'>Loading...</div> }
            </div>
        </div>

        <Link to={ this.props.link || to.link }
              onMouseOver={ this._handleLinkMouseover }
              onMouseOut={ this._handleLinkMouseout }
              style={{ color: nameColor }}
        >
            { this.props.name || to.name }
        </Link>
    </div>`
