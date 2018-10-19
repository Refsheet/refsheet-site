@User.Header = React.createClass
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

    `<div className='user-header'>
        <div className='container flex'>
            <div className='user-avatar'>
                <div className='image'>
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

                    <h1 className='name'>{ this.props.name }</h1>
                    <div className='username'>
                        @{ this.props.username }

                        { this.props.is_admin &&
                            <span className='user-badge admin-badge'>
                                <i className='material-icons'>security</i>
                            </span>
                        }

                        { this.props.is_patron &&
                            <span className='user-badge patron-badge' title='Patron'>
                                <img src='/assets/third_party/patreon_logo.png' alt='Patreon' />
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
