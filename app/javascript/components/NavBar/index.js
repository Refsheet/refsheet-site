import React, { Component } from 'react'
import { Link } from 'react-router-dom'

class NavBar extends Component {
  render() {
    const currentUser = null

    return (<div className='navbar-fixed user-bar'>
      <div className='navbar-shroud' onClick={ this.closeMenu } />

      <nav>
        <div className='container'>
          <ul className='menu left hide-on-med-and-up'>
            <li><a onClick={ this.toggleMenu }><i className='material-icons'>menu</i></a></li>
          </ul>

          <Link to='/' className='logo left'>
            <img src='/assets/logos/pumpkin2_64.png' alt='Refsheet.net' width='32' height='32' />
          </Link>

          <ul className='site-nav visible-on-med-and-up'>
            <li>
              <Link to='/' activeClassName='primary-text'>Home</Link>
            </li>

            <li>
              <Link to='/browse' activeClassName='primary-text'>Characters</Link>
            </li>

            <li>
              <Link to='/explore' activeClassName='primary-text'>Images</Link>
            </li>

            <li>
              <Link to='/forums' activeClassName='primary-text'>Forums</Link>
            </li>

            {/*<li>*/}
            {/*<Link to='/guilds' activeClassName='primary-text'>Guilds</Link>*/}
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
    </div>)
  }
}

NavBar.propTypes = {

}

export default NavBar
