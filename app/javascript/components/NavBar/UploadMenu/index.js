import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import compose from "../../../utils/compose";
import {connect} from "react-redux";
import WindowAlert from "../../../utils/WindowAlert";

class UploadMenu extends Component {
  renderNotification(n) {
    return (
      <NotificationItem key={n.id} {...n} />
    )
  }

  renderContent() {
    const {
      uploads = []
    } = this.props

    return <pre>{ JSON.stringify(uploads, null, 2) }</pre>
  }

  render() {
    const {
      uploads = []
    } = this.props

    const unreadCount = uploads.length

    if(!unreadCount) {
      WindowAlert.clean('uploads')
      return null;
    } else {
      WindowAlert.dirty('uploads', 'You have pending uploads!')
    }

    return (
      <DropdownLink icon='cloud_upload' count={unreadCount}>
        <div className='dropdown-menu wide'>
          <div className='title'>
            <div className='right'>
              <a href={'#'}>Accept All</a>
            </div>
            <strong>Uploads</strong>
          </div>
          <Scrollbars>
            <ul>
              {this.renderContent()}
            </ul>
          </Scrollbars>
          <Link to='/transfers' className='cap-link'>See More...</Link>
        </div>
      </DropdownLink>
    )
  }
}

UploadMenu.propTypes = {
  transfers: PropTypes.array
}

const mapStateToProps = (state, props) => ({
  uploads: state.uploads.files,
  ...props
})

export default compose(
  connect(mapStateToProps)
)(UploadMenu)