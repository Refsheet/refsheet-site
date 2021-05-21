import React from 'react'
import { NavLink } from 'react-router-dom'
import { withRouter } from 'react-router'
import { withTranslation } from 'react-i18next'
import Restrict from '../Shared/Restrict'

const SiteNav = ({ t }) => {
  return (
    <ul className="site-nav visible-on-med-and-up">
      <li>
        <NavLink to="/" exact activeClassName="primary-text">
          {t('nav.home', 'Home')}
        </NavLink>
      </li>

      <li>
        <NavLink to="/browse" activeClassName="primary-text">
          {t('nav.characters', 'Characters')}
        </NavLink>
      </li>

      <Restrict development>
        <li>
          <NavLink to="/artists" activeClassName="primary-text strong">
            {t('nav.artists', 'Artists')}
          </NavLink>
        </li>
      </Restrict>

      <li>
        <NavLink to="/explore" activeClassName="primary-text">
          {t('nav.images', 'Images')}
        </NavLink>
      </li>

      <li>
        <NavLink to="/forums" activeClassName="primary-text">
          {t('nav.forums', 'Forums')}
        </NavLink>
      </li>

      {/*<li>*/}
      {/*<NavLink to='/guilds' activeClassName='primary-text'>Guilds</NavLink>*/}
      {/*</li>*/}

      {/*<li>*/}
      {/*<NavLink to='/marketplace'>Marketplace</NavLink>*/}
      {/*</li>*/}
    </ul>
  )
}

SiteNav.propTypes = {}

export default withTranslation('common')(withRouter(SiteNav))
