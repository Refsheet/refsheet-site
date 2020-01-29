import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Summary from './Summary'
import styled from 'styled-components'

const Backdrop = styled.div`
  background-color: ${props => props.theme.imageBackground} !important;
`

class Header extends Component {
  render() {
    const { character, editable, onHeaderImageEdit, onAvatarEdit } = this.props
    const backgroundImage = (character.featured_image || { url: {} }).url.large

    return (
      <section className="page-header">
        <Backdrop
          className="page-header-backdrop"
          style={{ backgroundImage: 'url(' + backgroundImage + ')' }}
        >
          {onHeaderImageEdit && (
            <a
              className="image-edit-overlay for-header"
              onClick={onHeaderImageEdit}
            >
              <div className="content">
                <i className="material-icons">photo_camera</i>
                Change Cover Image
              </div>
            </a>
          )}
        </Backdrop>

        <div className="page-header-content">
          <div className="container">
            <Summary
              character={character}
              editable={editable}
              onAvatarEdit={onAvatarEdit}
            />
          </div>
        </div>
      </section>
    )
  }
}

Header.propTypes = { character: PropTypes.object.isRequired }

export default Header
