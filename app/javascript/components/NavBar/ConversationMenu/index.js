import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'

class ConversationMenu extends Component {
  componentWillUpdate(newProps) {

  }

  renderNotification(n) {
    return <NotificationItem key={ n.id } { ...n } />
  }

  render() {
    const {
      conversations=[],
      loading=false
    } = this.props

    const unreadCount = conversations.filter(c => c.is_unread).length

    return (
        <DropdownLink icon='message' count={unreadCount}>
          <div className='dropdown-menu wide'>
            <Scrollbars>
              <ul>
                {conversations.map(this.renderNotification)}
                {loading && <li className='empty-item'>Loading...</li>}
                {conversations.length > 0 || <li className='empty-item'>No new conversations.</li>}
              </ul>
            </Scrollbars>
            {conversations.length > 0 && <Link to='/conversations' className='cap-link'>See More...</Link>}
          </div>
        </DropdownLink>
    )
  }
}

ConversationMenu.propTypes = {
  conversations: PropTypes.array
}

export { ConversationMenu }

export default subscription(ConversationMenu)
