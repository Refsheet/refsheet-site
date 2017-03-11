@UserBar = React.createClass
  __init: ->
    console.log $('.user-bar .dropdown-button').dropdown
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
    Materialize.toast "Not implemented, yet.", 3000, 'yellow'


  render: ->
    if @props.currentUser?
      userMenu =
        `<ul id='user-menu' className='dropdown-content cs-card-background--background-color'>
            <li>
                <Link to={'/' + this.props.currentUser.username}>
                    <i className='material-icons left'>perm_identity</i>
                    <span>{ this.props.currentUser.username }</span>
                </Link>
            </li>

            <li className='divider' />

            <li>
                <a href='#' onClick={ this._handleNsfwToggle }>
                    <i className='material-icons left'>{ this.props.currentUser.nsfw_ok ? 'remove_circle' : 'remove_circle_outline' }</i>
                    <span>{ this.props.currentUser.nsfw_ok ? 'NSFW' : 'SFW' }</span>
                </a>
            </li>

            {/* log out */}
        </ul>`

      currentUser =
        `<ul className='right'>
            {/*<li>
                <Link to='/messages' activeClassName='teal-text text-lighten-2'>
                    <i className='material-icons'>message</i>
                </Link>
            </li>*/}

            <li>
                <a className='dropdown-button avatar' data-activates='user-menu'>
                    <img src={ this.props.currentUser.avatar_url } className='circle' />
                </a>

                { userMenu }
            </li>
        </ul>`

    else
      currentUser =
        `<ul className='right'>
            <li>
                <Link to='/login' activeClassName='teal-text text-lighten-2'>
                    <i className='material-icons'>perm_identity</i>
                </Link>
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
