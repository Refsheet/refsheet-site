namespace 'Views.Account.Notifications'

@Views.Account.Notifications.Card = v1 -> React.createClass
  propTypes:
    type: React.PropTypes.string.isRequired
    actionable: React.PropTypes.object
    actionables: React.PropTypes.array
    user: React.PropTypes.object.isRequired
    character: React.PropTypes.object
    timestamp: React.PropTypes.number.isRequired
    onReadChange: React.PropTypes.func.isRequired

  getInitialState: ->
    is_read: @props.is_read

  _getIdentity: ->
    if @props.character
      avatarUrl: @props.character.profile_image_url
      name: @props.character.name
      link: @props.character.link
      is_admin: @props.user.is_admin
      is_patron: @props.user.is_patron
      username: @props.user.username
      type: 'character'

    else
      avatarUrl: @props.user.avatar_url
      name: @props.user.name
      link: @props.user.link
      username: @props.user.username
      is_admin: @props.user.is_admin
      is_patron: @props.user.is_patron
      type: 'user'

  _getActionables: (key) ->
    out = @props.actionables || [ @props.actionable ]
    if typeof key isnt 'undefined'
      out = out.map (out) -> out[key]
    out

  _getActionable: ->
    return null unless @props.actionable

    switch @props.type
      when 'Notifications::ImageFavorite'
        `<Views.Account.Activities.Image images={ this._getActionables('media') } action='Likes' />`

      when 'Notifications::ImageComment'
        `<Views.Account.Activities.Comment comments={ this._getActionables() } />`

      when 'Notifications::ForumReply'
        `<Views.Account.Activities.ForumPost posts={ this._getActionables() } />`

      when 'Notifications::ForumTag'
        `<Views.Account.Activities.ForumPost action="Mentioned you in" posts={ this._getActionables() } />`

      else
        `<div className='red-text padding-bottom--medium'>
            { this.props.title } (Unsupported notification card)
            <br/>
            <Link to={this.props.href}>{this.props.message}</Link>
        </div>`

  componentWillReceiveProps: (newProps) ->
    if newProps.is_read isnt @state.is_read
      @setState is_read: newProps.is_read

  render: ->
    identity = @_getIdentity()

    if identity.is_admin
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'

    else if identity.is_patron
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'

    classNames = ['card sp with-avatar margin-bottom--medium notification']

    if @state.is_read
      unreadLink = \
        `<a href='#'
            onClick={ this.props.onReadChange(false, this.props.path) }
            className='right action-link done'
            data-tooltip='Mark Unread'
            title='Mark Unread'
        >
          <Icon>drafts</Icon>
        </a>`

    else
      unreadLink = \
        `<a href='#'
            onClick={ this.props.onReadChange(true, this.props.path) }
            className='right action-link'
            data-tooltip='Mark Read'
            title='Mark Read'
        >
          <Icon>done</Icon>
        </a>`

      classNames.push 'notification-unread'

    `<div className={classNames.join(' ')}>
        <img className='avatar circle' src={ identity.avatarUrl } alt={ identity.name } style={{ boxShadow: imgShadow }} />

        <div className='card-content padding-bottom--none'>
            <div className='muted right'>
                <DateFormat timestamp={ this.props.timestamp } fuzzy />
                { unreadLink }
            </div>
            <IdentityLink to={ identity } />

            { this._getActionable() }
        </div>

        <div className='clearfix' />
    </div>`
