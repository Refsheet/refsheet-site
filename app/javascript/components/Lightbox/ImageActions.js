import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Icon, Dropdown } from 'react-materialize'

class ImageActions extends Component {
  render() {
    return <div className={'image-actions'}>
      <div className={'image-action-menu'}>
        <Dropdown trigger={<a href={'#image-options'}>
            <Icon>more_vert</Icon>
          </a>}>
          <a href={'#'}>Edit</a>
        </Dropdown>
      </div>
    </div>
  }
}

ImageActions.propTypes = {

}

export default ImageActions