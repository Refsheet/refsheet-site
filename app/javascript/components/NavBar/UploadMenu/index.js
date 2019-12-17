import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import compose from '../../../utils/compose'
import { connect } from 'react-redux'
import WindowAlert from '../../../utils/WindowAlert'
import { clearAllUploads, clearUpload, openUploadModal } from '../../../actions'

class UploadMenu extends Component {
  handleUploadDismiss(args) {
    this.props.clearUpload(args.variables.id)
  }

  handleUploadClick(args) {
    console.log({ args })
    this.props.openUploadModal(args.variables.id, null)
  }

  handleClearAllClick(e) {
    e.preventDefault()
    this.props.clearAllUploads()
  }

  renderNotification(n) {
    /*
    "preview": "blob:http://dev1.refsheet.net:5000/b9c2da79-f7a8-4093-8c1c-bcafdb25154f",
    "id": 0,
    "title": "Dec 01 19",
    "folder": "default",
    "nsfw": false,
    "state": "pending",
    "progress": 0
     */

    return (
      <NotificationItem
        key={n.id}
        id={n.id}
        thumbnail={n.preview}
        title={n.title}
        is_unread={n.state === 'pending'}
        onDismiss={this.handleUploadDismiss.bind(this)}
        onClick={this.handleUploadClick.bind(this)}
        dismissIcon={'close'}
      />
    )
  }

  render() {
    const { uploads = [] } = this.props

    const unreadCount = uploads.length

    if (!unreadCount || unreadCount === 0) {
      WindowAlert.clean('uploads')
      return null
    } else {
      WindowAlert.dirty('uploads', 'You have pending uploads!')
    }

    return (
      <DropdownLink icon="cloud_upload" count={unreadCount}>
        <div className="dropdown-menu wide">
          <div className="title">
            <div className="right">
              <a href={'#'} onClick={this.handleClearAllClick.bind(this)}>
                Clear All
              </a>
            </div>
            <strong>Pending Uploads</strong>
          </div>
          <Scrollbars>
            <ul>{uploads.map(this.renderNotification.bind(this))}</ul>
          </Scrollbars>
        </div>
      </DropdownLink>
    )
  }
}

UploadMenu.propTypes = {
  transfers: PropTypes.array,
}

const mapStateToProps = (state, props) => ({
  uploads: state.uploads.files,
  ...props,
})

const mapDispatchToProps = {
  clearUpload,
  clearAllUploads,
  openUploadModal,
}

export default compose(connect(mapStateToProps, mapDispatchToProps))(UploadMenu)
