import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'
import markAllNotificationsAsRead from './markAllNotificationsAsRead.graphql'
import readNotification from './readNotification.graphql'
import WindowAlert from '../../../utils/WindowAlert'
import compose, { withMutations } from '../../../utils/compose'
import { withTranslation } from 'react-i18next'

class NotificationMenu extends Component {
  constructor(props) {
    super(props)

    this.state = {
      markAllLoading: false,
    }
  }

  UNSAFE_componentWillReceiveProps(newProps) {
    if (this.props.unreadCount < newProps.unreadCount) {
      WindowAlert.playSound('notificationDing')
    }
  }

  handleMarkAllClick(e) {
    const { unreadCount, loading = false, refetch, markAllAsRead } = this.props

    e.preventDefault()
    this.setState({ markAllLoading: true })

    if (unreadCount !== 0 && !loading && markAllAsRead) {
      markAllAsRead()
        .then(_data => {
          if (refetch) refetch()
          this.setState({ markAllLoading: false })
        })
        .catch(console.error)
    }
  }

  render() {
    const {
      notifications = [],
      loading = false,
      error,
      refetch,
      unreadCount,
      readNotification,
      t,
    } = this.props

    const renderNotification = n => (
      <NotificationItem
        key={n.id}
        {...n}
        onDismiss={readNotification}
        refetch={refetch}
      />
    )

    const renderContent = () => {
      if (loading) {
        return <li className="empty-item">Loading...</li>
      } else if (error) {
        return <li className="empty-item red-text">{JSON.stringify(error)}</li>
      } else if (notifications.length > 0) {
        return notifications.map(renderNotification)
      } else {
        return <li className="empty-item">No new notifications.</li>
      }
    }

    const tryRefetch = () => {
      if (refetch) refetch()
    }

    return (
      <DropdownLink
        icon="notifications"
        count={unreadCount}
        onOpen={tryRefetch}
      >
        <div className="dropdown-menu wide">
          <div className="title">
            <div className="right">
              <a
                href={'/notifications'}
                onClick={this.handleMarkAllClick.bind(this)}
                className={this.state.markAllLoading ? 'disabled' : ''}
              >
                {this.state.markAllLoading
                  ? t('status.wait', 'Please wait...')
                  : t('notifications.mark_all_read', 'Mark All Read')}
              </a>
            </div>
            <strong>Notifications</strong>
          </div>
          <Scrollbars>
            <ul>{renderContent()}</ul>
          </Scrollbars>
          <Link to="/notifications" className="cap-link">
            See More...
          </Link>
        </div>
      </DropdownLink>
    )
  }
}

NotificationMenu.propTypes = {
  notifications: PropTypes.array,
  unreadCount: PropTypes.number,
}

export { NotificationMenu }

export default compose(
  subscription,
  withTranslation('common'),
  withMutations({ markAllAsRead: markAllNotificationsAsRead, readNotification })
)(NotificationMenu)
