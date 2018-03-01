namespace 'Views.Account.Notifications'

@Views.Account.Notifications.Card = React.createClass
  propTypes:
    type: React.PropTypes.string.isRequired
    actionable: React.PropTypes.object
    actionables: React.PropTypes.array
    user: React.PropTypes.object.isRequired
    character: React.PropTypes.object
    timestamp: React.PropTypes.number.isRequired

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

  _getActionables: ->
    @props.actionables || [ @props.actionable ]

  _getActionable: ->
    return unless @props.actionable

    switch @props.type
#      when 'Notifications::ImageFavorite'
#        `<Views.Account.Activities.Image images={ this._getActionables() } character={ this.props.character } />`
#
      when 'Notifications::ImageComment'
        `<Views.Account.Activities.Comment comments={ this._getActionables() } />`
#
#      when 'Notifications::ForumReply'
#        `<Views.Account.Activities.ForumDiscussion characters={ this._getActionables() } username={ this.props.user.username } />`
#
#      when 'Notifications::ForumMention'
#        `<Views.Account.Activities.ForumDiscussion characters={ this._getActionables() } username={ this.props.user.username } />`

      else
        `<div className='red-text padding-bottom--medium'>
            { this.props.title } (Unsupported notification card)
            <br/>
            <Link to={this.props.href}>{this.props.message}</Link>
        </div>`

  render: ->
    { date, dateHuman } = @props
    identity = @_getIdentity()

    if identity.is_admin
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'

    else if identity.is_patron
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'

    `<div className='card sp with-avatar margin-bottom--medium'>
        <img className='avatar circle' src={ identity.avatarUrl } alt={ identity.name } style={{ boxShadow: imgShadow }} />

        <div className='card-content padding-bottom--none'>
            <DateFormat className='muted right' timestamp={ this.props.timestamp } fuzzy />
            <IdentityLink to={ identity } />

            { this._getActionable() }
        </div>

        <div className='clearfix' />
    </div>`
