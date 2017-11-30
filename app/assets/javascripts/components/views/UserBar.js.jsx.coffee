@UserBar = React.createClass
  contextTypes:
    currentUser: React.PropTypes.object


  __init: ->
    $('.user-bar .dropdown-button').dropdown
      constrain_width: false

  componentDidUpdate: ->
    @__init()

  componentDidMount: ->
    @__init()

    $(document)
      .on 'navigate.navbar', =>
        @closeMenu()
      .on 'click.navbar', =>
        @closeMenu()
        @_handleUserMenuClose()

  toggleMenu: ->
    if $('.site-nav').is(':visible')
      $('.site-nav').fadeOut(150)
      $('.navbar-shroud').fadeOut(150)

    else
      $('.site-nav').fadeIn(300)
      $('.navbar-shroud').fadeIn(300)

  closeMenu: ->
    $('.site-nav').fadeOut(150)
    $('.navbar-shroud').fadeOut(150)

  _handleUserMenuToggle: ->
    $m = $ @refs.userMenu

    if $m.is(':visible')
      $m.slideUp 150
    else
      $m.slideDown 300

  _handleUserMenuClose: ->
    $m = $ @refs.userMenu
    $m.slideUp 150

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
      success: (data) =>
        $(document).trigger 'app:session:update', data
        Materialize.toast "See you later!", 3000, 'green'
    e.preventDefault()


  render: ->
    nsfwClassName = if @props.session.nsfw_ok then 'nsfw-on' else ''

    if @props.session.current_user?
      userMenu =
        `<ul className='dropdown-content-native cs-card-background--background-color' ref='userMenu'>
            <li>
                <Link to={'/' + this.props.session.current_user.username}>
                    <i className='material-icons left'>person</i>
                    <span>{ this.props.session.current_user.username }</span>
                </Link>
            </li>

            { this.props.session.current_user.is_admin &&
                <li>
                    <a href='/admin'>
                        <i className='material-icons left'>vpn_key</i>
                        <span>Admin</span>
                    </a>
                </li>
            }

            <li className='divider' />

            <li>
                <a onClick={ this._handleNsfwToggle } className={ nsfwClassName }>
                    <i className='material-icons left'>{ this.props.session.nsfw_ok ? 'remove_circle' : 'remove_circle_outline' }</i>
                    <span>{ this.props.session.nsfw_ok ? 'Hide NSFW' : 'Show NSFW' }</span>
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
                <a className={ 'dropdown-button-native avatar ' + nsfwClassName } onClick={ this._handleUserMenuToggle }>
                    <img src={ this.props.session.current_user.avatar_url } className='circle' />
                </a>

                { userMenu }
            </li>
        </ul>`

    else
      userMenu =
        `<ul className='dropdown-content-native cs-card-background--background-color' ref='userMenu'>
            <li>
                <a href='#session-modal' className='modal-trigger'>
                    <i className='material-icons left'>person</i>
                    <span>Sign In</span>
                </a>
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
                    <span>{ this.props.session.nsfw_ok ? 'Hide NSFW' : 'Show NSFW' }</span>
                </a>
            </li>
        </ul>`

      currentUser =
        `<ul className='right'>
            <li>
                <a className={ 'dropdown-button-native ' + nsfwClassName } onClick={ this._handleUserMenuToggle }>
                    <i className='material-icons'>perm_identity</i>
                </a>

                { userMenu }
            </li>
        </ul>`

    `<div className='navbar-fixed user-bar'>
        <div className='navbar-shroud' onClick={ this.closeMenu } />

        <nav>
          <div className='container'>
              <ul className='menu left hide-on-med-and-up'>
                  <li><a onClick={ this.toggleMenu }><i className='material-icons'>menu</i></a></li>
              </ul>

              <Link to='/' className='logo left'>
                  <img src='/assets/logos/RefsheetLogo_64.png' alt='Refsheet.net' width='32' height='32' />
              </Link>

              <ul className='site-nav visible-on-med-and-up'>
                  <li>
                      <Link to='/browse' activeClassName='teal-text text-lighten-2'>Characters</Link>
                  </li>

                  <li>
                      <Link to='/explore' activeClassName='teal-text text-lighten-2'>Images</Link>
                  </li>

                  { (this.context.currentUser) &&
                      <li>
                          <Link to='/forums' activeClassName='teal-text text-lighten-2'>Forums</Link>
                      </li>
                  }

                  {/*<li>*/}
                      {/*<Link to='/guilds' activeClassName='teal-text text-lighten-2'>Guilds</Link>*/}
                  {/*</li>*/}

                  {/*<li>*/}
                      {/*<Link to='/marketplace'>Marketplace</Link>*/}
                  {/*</li>*/}
              </ul>

              <div className='right'>
                  <SearchBar query={ this.props.query } />

                  { currentUser }
              </div>
          </div>
        </nav>
    </div>`
