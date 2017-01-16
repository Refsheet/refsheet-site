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
        <div className='container flex'>
            <div className='user-avatar'>
                <div className='image'>
                    <img src={ this.props.profile_image_url } alt={ this.props.username } />
                    <div className='slant' />
                </div>
            </div>
            <div className='user-data'>
                <h1 className='name'>{ this.props.name }</h1>
                <div className='username'>@{ this.props.username }</div>
                <RichText className='user-bio'
                          content={ this.props.profile }
                          markup={ this.props.profile_markup }
                          onChange={ bioChangeCallback } />
            </div>
        </div>
    </div>`
