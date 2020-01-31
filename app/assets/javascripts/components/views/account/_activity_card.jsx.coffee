@Views.Account.ActivityCard = v1 -> React.createClass
  propTypes:
    activityType: React.PropTypes.string
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

  _getActivities: ->
    @props.activities || [ @props.activity ]

  _getActivity: ->
    return unless @props.activity || @props.comment

    switch @props.activityType
      when 'Image'
        `<Views.Account.Activities.Image images={ this._getActivities() } character={ this.props.character } />`

      when 'Media::Comment'
        `<Views.Account.Activities.Comment comments={ this._getActivities() } />`

      when 'Character'
        `<Views.Account.Activities.Character characters={ this._getActivities() } username={ this.props.user.username } />`

      when 'Forum::Discussion'
        `<Views.Account.Activities.ForumDiscussion discussions={ this._getActivities() } />`

      else
        if @props.comment
          `<Views.Account.Activities.StatusUpdate comment={ this.props.comment } />`
        else
          `<div className='red-text padding-bottom--medium'>Unsupported activity type: {this.props.activityType}.{this.props.activityMethod}</div>`

  render: ->
    return `<ActivityCard {...this.props} />`

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

        <div className='card-content padding-bottom--medium'>
            <IdentityLink to={ identity } /> uploaded four images
            <div className='date'>
              <DateFormat className='muted' timestamp={ this.props.timestamp } fuzzy />
            </div>
        </div>

        { this._getActivity() }

        <div className='clearfix' />
    </div>`
