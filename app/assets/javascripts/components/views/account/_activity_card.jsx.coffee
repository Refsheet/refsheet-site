@Views.Account.ActivityCard = React.createClass
  propTypes:
    activityType: React.PropTypes.string.isRequired
    activityMethod: React.PropTypes.string
    activityField: React.PropTypes.string
    activity: React.PropTypes.object
    activities: React.PropTypes.array
    user: React.PropTypes.object.isRequired
    character: React.PropTypes.object
    timestamp: React.PropTypes.number.isRequired

  _getIdentity: ->
    if @props.character
      avatarUrl: @props.character.profile_image_url
      name: @props.character.name
      link: @props.character.link
      username: @props.user.username
      type: 'character'

    else
      avatarUrl: @props.user.avatar_url
      name: @props.user.name
      link: @props.user.link
      username: @props.user.username
      type: 'user'

  _getActivities: ->
    @props.activities || [ @props.activity ]

  _getActivity: ->
    return unless @props.activity

    switch @props.activityType
      when 'Image'
        `<Views.Account.Activities.Image images={ this._getActivities() } character={ this.props.character } />`

      when 'Media::Comment'
        `<Views.Account.Activities.Comment comments={ this._getActivities() } />`

      when 'Character'
        `<Views.Account.Activities.Character characters={ this._getActivities() } username={ this.props.user.username } />`

      else
        `<div className='red-text padding-bottom--medium'>Unsupported activity type: {this.props.activityType}.{this.props.activityMethod}</div>`

  render: ->
    { date, dateHuman } = @props
    identity = @_getIdentity()

    `<div className='card sp with-avatar margin-bottom--medium'>
        <img className='avatar circle' src={ identity.avatarUrl } alt={ identity.name } />

        <div className='card-content padding-bottom--none'>
            <DateFormat className='muted right' timestamp={ this.props.timestamp } fuzzy />
            <IdentityLink to={ identity } />

            { this._getActivity() }
        </div>

        <div className='clearfix' />
    </div>`
