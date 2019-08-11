import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import DropdownLink from './DropdownLink'
import Restrict from "../Shared/Restrict";
import {withNamespaces} from "react-i18next";
import IdentityModal from "../Shared/CommentForm/IdentityModal";

class UserMenu extends Component {
  constructor(props) {
    super(props)

    this.state = {
      identityModalOpen: false
    }
  }

  render() {
    const {user, nsfwOk, onNsfwClick, onLogoutClick, onIdentityClick, identity, t} = this.props
    const nsfwClassName = nsfwOk ? 'nsfw' : 'no-nsfw'

    return (
      <DropdownLink imageSrc={ identity.avatarUrl } className={nsfwClassName}>
        <ul className='dropdown-menu'>
          <li>
            <Link to={'/' + user.username}>
              <i className='material-icons left'>{ identity.characterId !== null ? "people" : "person" }</i>
              <span>{ identity.name }</span><br />
              <span className='muted'>@{ user.username }</span>
            </Link>
          </li>

          <Restrict patron>
            <li>
              <a href={'#identity-select'} onClick={ onIdentityClick }>
                <i className={'material-icons left'}>swap_horiz</i>
                <span>{ t('identity.change', 'Change Identity') }</span>
              </a>
            </li>
          </Restrict>

          <Restrict admin>
            <li>
              <a href='/admin' target={'_blank'}>
                <i className='material-icons left'>vpn_key</i>
                <span>{ t('nav.admin', 'Admin') }</span>
              </a>
            </li>
          </Restrict>

          <li className='divider' />

          <li>
            <a onClick={ onNsfwClick } className={ nsfwClassName }>
              <i className='material-icons left'>{ nsfwOk ? 'remove_circle' : 'remove_circle_outline' }</i>
              <span>{ nsfwOk ? t('nav.hide-nsfw', 'Hide NSFW') : t('nav.show-nsfw', 'Show NSFW') }</span>
            </a>
          </li>

          <li>
            <a onClick={ onLogoutClick }>
              <i className='material-icons left'>exit_to_app</i>
              <span>{ t('nav.logout', 'Sign Out') }</span>
            </a>
          </li>
        </ul>
      </DropdownLink>
    )
  }
}

UserMenu.propTypes = {
  nsfwOk: PropTypes.bool,
  user: PropTypes.shape({
    username: PropTypes.string.isRequired
  }),
  onNsfwClick: PropTypes.func.isRequired,
  onLogoutClick: PropTypes.func.isRequired,
  onIdentityClick: PropTypes.func.isRequired
}

export default withNamespaces('common')(UserMenu)
