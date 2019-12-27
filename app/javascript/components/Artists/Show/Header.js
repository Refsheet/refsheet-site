import React from 'react'
import PropTypes from 'prop-types'
import RichText from '../../Shared/RichText'
import ContactLinks from '../../Shared/ContactLinks'

const Header = ({
  avatarUrl,
  name,
  category,
  profile,
  profileMarkdown,
  links,
}) => {
  return (
    <div className={'user-header'}>
      <div className={'container flex'}>
        <div className={'user-avatar'}>
          <div className={'image'}>
            <img src={avatarUrl} alt={name} />
          </div>
        </div>

        <div className={'user-data'}>
          <div className={'avatar-shift'}>
            {/*<a href={'#'} className={'secondary-content btn btn-flat right'}*/}
            {/*   style={{ border: '1px solid rgba(255, 255, 255, 0.1'}}>*/}
            {/*  <span className={'hide-on-med-and-down'}>Closed</span>*/}
            {/*  <i className={'material-icons right'} style={{ color: 'rgba(255, 255, 255, 0.7' }}>remove_circle</i>*/}
            {/*</a>*/}

            <h1 className={'name'}>
              {name}
              <i
                className={
                  'material-icons cyan-text text-darken-3 padding-left--medium'
                }
              >
                check
              </i>
            </h1>

            <div className={'row no-margin'}>
              <div className={'col s12 m6'}>
                <div className={'username'}>{category || 'Artist'}</div>
                <div className={'user-bio'}>
                  <RichText content={profile}>{profileMarkdown}</RichText>
                </div>
              </div>
              <div className={'col s12 m6'}>
                <ContactLinks links={links} />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

Header.propTypes = {
  avatarUrl: PropTypes.string,
  name: PropTypes.string.isRequired,
  username: PropTypes.string,
  category: PropTypes.string,
  profile: PropTypes.string,
  profileMarkdown: PropTypes.string,
}

export default Header
