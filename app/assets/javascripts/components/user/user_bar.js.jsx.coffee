@UserBar = ->
  `<div className='navbar-fixed user-bar'>
      <nav>
        <div className='container'>
            <ul>
                <li>
                    <a href='#!/' className='logo'>
                        <img src='https://placehold.it/144x50' />
                    </a>
                </li>

                <li><a href='#!/marketplace'>Marketplace</a></li>
                <li><a href='#!/guilds'>Guilds</a></li>
                <li><a href='#!/search'>Search</a></li>
            </ul>

            <ul className='right'>
                <li>
                    <a href='#!/messages'>
                        <i className='material-icons'>message</i>
                    </a>
                </li>
                
                <li>
                    <a href='#!/users/MauAbata' className='avatar'>
                        <img src='https://placehold.it/100' className='circle' />
                    </a>
                </li>
            </ul>
        </div>
      </nav>
  </div>`
