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

    `<div className='user-header'>
        <div className='parallax-container'>
            <div className='parallax'>
                <img src={ this.props.cover_image_url } />
            </div>
        </div>

        <div className='tab-row'>
            <div className='container'>
                <div className='user-avatar'>
                    <div className='image'>
                        <img src={ this.props.profile_image_url } alt={ this.props.username } />
                        <div className='slant' />
                    </div>
                </div>
                <div className='user-data'>
                    <h1 className='name'>{ this.props.name }</h1>
                    <div className='username'>@{ this.props.username }</div>
                </div>
                {/*<div className='user-actions'>
                    <Link to={ '/messages/' + this.props.username }>
                        <i className='material-icons'>messages</i>
                    </Link>
                </div>*/}
            </div>
        </div>

        <div className='container'>
            <RichText className='user-bio'
                      content={ this.props.profile }
                      markup={ this.props.profile_markup }
                      onChange={ bioChangeCallback } />
        </div>
    </div>`
