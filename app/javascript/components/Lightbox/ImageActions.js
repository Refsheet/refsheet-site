import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon, Dropdown, Divider } from 'react-materialize'

class ImageActions extends Component {
  handleEditClick(e) {
    e.preventDefault()
    this.props.onEditClick && this.props.onEditClick()
  }

  render() {
    return (
      <div className={'image-actions'}>
        <div className={'image-action-menu'}>
          <a href={'#edit-image'} onClick={this.handleEditClick.bind(this)}>
            <Icon>edit</Icon>
          </a>
        </div>

        <div className={'image-action-menu'}>
          <Dropdown
            options={{
              alignment: 'right',
              constrainWidth: false,
              closeOnClick: true,
            }}
            trigger={
              <a href={'#image-options'}>
                <Icon>more_vert</Icon>
              </a>
            }
          >
            <a href={'#'}>Set as Cover Image</a>
            <a href={'#'}>Set as Profile Image</a>
            <Divider />
            <a href={'#'}>
              <Icon className={'left'}>crop</Icon>
              <span>Cropping...</span>
            </a>
            <Divider />
            <a href={'#'}>
              <Icon className={'left'}>file_download</Icon>{' '}
              <span>Download</span>
            </a>
            <a href={'#'}>
              <Icon className={'left'}>forward</Icon>
              <span>Transfer To...</span>
            </a>
            <a href={'#'}>
              <Icon className={'left'}>delete</Icon> <span>Delete...</span>
            </a>
          </Dropdown>
        </div>
      </div>
    )
  }
}

ImageActions.propTypes = {
  onEditClick: PropTypes.func,
}

export default ImageActions
