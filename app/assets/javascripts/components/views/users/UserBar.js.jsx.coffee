@UserBar = React.createClass
  __init: ->
    $('.user-bar .dropdown-button').dropdown
      constrain_width: false

  componentDidUpdate: ->
    @__init()

  componentDidMount: ->
    @__init()

  toggleMenu: ->
    if $('.site-nav').is(':visible')
      $('.site-nav').fadeOut(300)
      $('.navbar-shroud').fadeOut(300)
    else
      $('.site-nav').fadeIn(300)
      $('.navbar-shroud').fadeIn(300)

  closeMenu: ->
    $('.site-nav').fadeOut(300)
    $('.navbar-shroud').fadeOut(300)

  _handleNsfwToggle: ->
    $.ajax
      url: '/session'
      type: 'PATCH'
      data: nsfw_ok: !@props.session.nsfw_ok
      success: (session) =>
        $(document).trigger 'app:session:update', session
        Materialize.toast "NSFW mode is #{if session.nsfw_ok then 'on' else 'off'}.", 3000, 'green'
      error: (data) =>
        console.error data
        Materialize.toast "Unable to set NSFW mode!", 3000, 'red'

  _handleSignOut: (e) ->
    $.ajax
      url: '/session'
      type: 'DELETE'
      success: =>
        $(document).trigger 'app:session:update', null
        Materialize.toast "See you later!", 3000, 'green'
    e.preventDefault()


  render: ->
    nsfwClassName = if @props.session.nsfw_ok then 'materialize-red darken-1' else ''

    if @props.session.current_user?
      userMenu =
        `<ul id='user-menu' className='dropdown-content cs-card-background--background-color'>
            <li>
                <Link to={'/' + this.props.session.current_user.username}>
                    <i className='material-icons left'>perm_identity</i>
                    <span>{ this.props.session.current_user.username }</span>
                </Link>
            </li>

            <li className='divider' />

            <li>
                <a onClick={ this._handleNsfwToggle } className={ nsfwClassName }>
                    <i className='material-icons left'>{ this.props.session.nsfw_ok ? 'remove_circle' : 'remove_circle_outline' }</i>
                    <span>{ this.props.session.nsfw_ok ? 'NSFW' : 'SFW' }</span>
                </a>
            </li>

            <li>
                <a onClick={ this._handleSignOut }>
                    <i className='material-icons left'>exit_to_app</i>
                    <span>Sign Out</span>
                </a>
            </li>
        </ul>`

      currentUser =
        `<ul className='right'>
            {/*<li>
                <Link to='/messages' activeClassName='teal-text text-lighten-2'>
                    <i className='material-icons'>message</i>
                </Link>
            </li>*/}

            <li>
                <a className={ 'dropdown-button avatar ' + nsfwClassName } data-activates='user-menu'>
                    <img src={ this.props.session.current_user.avatar_url } className='circle' />
                </a>

                { userMenu }
            </li>
        </ul>`

    else
      userMenu =
        `<ul id='user-menu' className='dropdown-content cs-card-background--background-color'>
            <li>
                <Link to='/login'>
                    <i className='material-icons left'>person</i>
                    <span>Sign In</span>
                </Link>
            </li>
            <li>
                <Link to='/register'>
                    <i className='material-icons left'>create</i>
                    <span>Register</span>
                </Link>
            </li>

            <li className='divider' />

            <li>
                <a onClick={ this._handleNsfwToggle } className={ nsfwClassName }>
                    <i className='material-icons left'>{ this.props.session.nsfw_ok ? 'remove_circle' : 'remove_circle_outline' }</i>
                    <span>{ this.props.session.nsfw_ok ? 'NSFW' : 'SFW' }</span>
                </a>
            </li>
        </ul>`

      currentUser =
        `<ul className='right'>
            <li>
                <a className={ 'dropdown-button ' + nsfwClassName } data-activates='user-menu'>
                    <i className='material-icons'>perm_identity</i>
                </a>

                { userMenu }
            </li>
        </ul>`

    `<div className='navbar-fixed user-bar'>
        <div className='navbar-shroud' onClick={ this.closeMenu } />

        <nav>
          <div className='container-fluid'>
              <ul className='menu left hide-on-med-and-up'>
                  <li><a onClick={ this.toggleMenu }><i className='material-icons'>menu</i></a></li>
              </ul>

              <Link to='/' className='logo left'>
                  <img src='/assets/logos/RefsheetLogo_64.png' alt='Refsheet.net' width='32' height='32' />
                  <span className='site-name'>
                      <span className='logo-r'>R</span>efsheet
                  </span>
              </Link>

              <ul className='site-nav visible-on-med-and-up'>
                  <li>
                      <a href='https://www.patreon.com/refsheet' className='patreon'>
                          <img src='/assets/third_party/patreon_white.png' alt='Patreon' />
                      </a>
                  </li>

                  <li>
                      <Link to='/browse' activeClassName='teal-text text-lighten-2'>Browse</Link>
                  </li>

                  {/*<li>
                      <Link to='/guilds' activeClassName='teal-text text-lighten-2'>Guilds</Link>
                  </li>
                  <li>
                      <Link to='/search' activeClassName='teal-text text-lighten-2'>Search</Link>
                  </li>*/}
              </ul>

              { currentUser }
          </div>
        </nav>
    </div>`
