import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'
import {Mutation} from "react-apollo"
import {markAllNotificationsAsRead} from "./markAllNotificationsAsRead.graphql"
import {readNotification} from "./readNotification.graphql"

class NotificationMenu extends Component {
  componentWillReceiveProps(newProps) {
    if (this.props.unreadCount < newProps.unreadCount) {
      console.log("Play WOO!")
    }
  }

  handleMarkAllClick(e) {
    const {
      unreadCount,
      loading=false,
      refetch,
      markAllAsRead
    } = this.props

    e.preventDefault()

    if (unreadCount !== 0 && !loading && markAllAsRead) {
      markAllAsRead()
        .then((_data) => {
          if(refetch) refetch()
        })
        .catch(console.error)
    }
  }

  render() {
    const {
      notifications=[],
      unreadCount,
      loading=false,
      error,
      subscribe,
      refetch,
      readNotification
    } = this.props

    const renderNotification = (n) => (
      <NotificationItem key={n.id} {...n} onDismiss={readNotification} refetch={refetch} />
    )

    if (!loading && !error)
      subscribe()

    const renderContent = () => {
      if (loading) {
        return <li className='empty-item'>Loading...</li>
      } else if (error) {
        return <li className='empty-item red-text'>{error}</li>
      } else if (notifications.length > 0) {
        return notifications.map(renderNotification)
      } else {
        return <li className='empty-item'>No new notifications.</li>
      }
    }

    const tryRefetch = () => {
      if (refetch) refetch()
    }

    return (
      <DropdownLink icon='notifications' count={unreadCount} onOpen={tryRefetch}>
        <div className='dropdown-menu wide'>
          <div className='title'>
            <div className='right'>
              <a href={'/notifications'} onClick={this.handleMarkAllClick.bind(this)}>Mark All Read</a>
            </div>
            <strong>Notifications</strong>
          </div>
          <Scrollbars>
            <ul>
              {renderContent()}
            </ul>
          </Scrollbars>
          <Link to='/notifications' className='cap-link'>See More...</Link>
        </div>
      </DropdownLink>
    )
  }
}

NotificationMenu.propTypes = {
  notifications: PropTypes.array,
  unreadCount: PropTypes.number
}

export { NotificationMenu }

const Mutated = (props) => (
  <Mutation mutation={markAllNotificationsAsRead}>
    { (markAllAsRead) => (
      <Mutation mutation={readNotification}>
        { (readNotification) => <NotificationMenu {...props} markAllAsRead={markAllAsRead} readNotification={readNotification} /> }
      </Mutation>
    )}
  </Mutation>
)

export default subscription(Mutated)
