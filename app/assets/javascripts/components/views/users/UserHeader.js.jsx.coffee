@UserHeader = React.createClass
  componentDidMount: ->
    $('.parallax').parallax()

  handleBioChange: (markup, success) ->
    $.ajax
      url: @props.path
      type: 'PATCH'
      data: user: profile: markup
      success: (user) =>
        @props.onUserChange(user)
        success(user)

  render: ->
    if @props.onUserChange?
      bioChangeCallback = @handleBioChange
      editable = true

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
                <h1 className='name'>{ this.props.name }</h1>
                <div className='username'>@{ this.props.username }</div>
                <div className='user-bio'>
                    <RichText content={ this.props.profile }
                              markup={ this.props.profile_markup }
                              onChange={ bioChangeCallback } />
                </div>
            </div>

            <div className='user-actions'>
                { editable &&
                    <a className='btn waves-effect btn-small waves-light modal-trigger' href='#user-settings-modal'>
                        Edit Account
                    </a>
                }

                { this.props.is_admin &&
                    <div className='user-badge indigo darken-1 white-text'>
                        ADMIN
                    </div>
                }

                { this.props.is_patron &&
                    <div className='user-badge'>
                        <img src='/assets/third_party/patreon_logo.png' alt='Patreon' />
                        Proud Patron!
                    </div>
                }
            </div>
        </div>
    </div>`
