@User.Header = v1 -> React.createClass
  contextTypes:
    currentUser: React.PropTypes.object

  propTypes:
    onFollow: React.PropTypes.func.isRequired

  handleBioChange: (markup, success) ->
    $.ajax
      url: @props.path
      type: 'PATCH'
      data: user: profile: markup
      success: (user) =>
        @props.onUserChange(user)
        success(user)

  _handleFollowClick: (e) ->
    action = if @props.followed then 'delete' else 'post'
    Model.request action, '/users/' + @props.username + '/follow.json', {}, (user) =>
      @props.onFollow user.followed
    e.preventDefault()

  render: ->
    if @props.onUserChange?
      bioChangeCallback = @handleBioChange
      followCallback = @props.onFollow
      editable = true

    if @context.currentUser and @props.username != @context.currentUser.username
      canFollow = true
      followColor = if @props.followed then '#ffca28' else 'rgba(255, 255, 255, 0.7)'

    userColor = UserUtils.userFgColor(this.props)
    userBgColor = UserUtils.userBgColor(this.props)

    if userColor
      imageStyle = { boxShadow: "#{userColor} 0px 0px 3px 1px" }

    `<div className='user-header' style={{ backgroundColor: userBgColor }}>
        <div className='container flex'>
            <div className='user-avatar'>
                <div className='image' style={imageStyle}>
                    { editable &&
                        <div className='image-edit-overlay'>
                            <div className='content'>
                                <i className='material-icons'>photo_camera</i>
                                Change Avatar
                            </div>
                        </div>
                    }

                    <img src={ this.props.profile_image_url } alt={ this.props.username } />
                </div>
            </div>
            <div className='user-data'>
                <div className='avatar-shift'>
                    { canFollow &&
                        <a href='#' className='secondary-content btn btn-flat right' style={{ border: '1px solid rgba(255,255,255,0.1)' }} onClick={ this._handleFollowClick }>
                            <span className='hide-on-med-and-down'>{ this.props.followed ? 'Following' : 'Follow' }</span>
                            <Icon style={{ color: followColor }} className='right'>person_add</Icon>
                        </a> }

                    <h1 className='name' style={{color: userColor}}>{ this.props.name }</h1>
                    <div className='username'>
                        @{ this.props.username }

                        { this.props.is_admin &&
                            <span className='user-badge admin-badge' title="Site administrator">
                                <i className='material-icons' style={{color: UserUtils.USER_FG_COLOR.admin}}>security</i>
                            </span>
                        }

                        { this.props.is_patron &&
                            <span className='user-badge patron-badge' title='Site Patron'>
                                <img src='/assets/third_party/patreon_logo.png' alt='Patreon' />
                            </span>
                        }

                        { this.props.is_supporter &&
                            <span className='user-badge supporter-badge' title='Site Supporter'>
                                <i className='material-icons' style={{color: UserUtils.USER_FG_COLOR.supporter}}>star</i>
                            </span>
                        }
                    </div>
                </div>
                <div className='user-bio'>
                    <RichText content={ this.props.profile }
                              markup={ this.props.profile_markup }
                              onChange={ bioChangeCallback } />
                </div>
            </div>
        </div>
    </div>`
