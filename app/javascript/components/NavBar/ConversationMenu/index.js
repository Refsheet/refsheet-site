import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'
import { formatBody } from '../../Chat/ConversationMessage'

class ConversationMenu extends Component {
  componentWillUpdate(newProps) {

  }

  renderConversation(c) {
    console.log({conversation: c})
    return <NotificationItem
        key={ c.id }
        icon={c.user.avatar_url}
        created_at={c.lastMessage ? c.lastMessage.created_at : c.created_at}
        title={<span>
          <strong>{c.user.name}</strong><br/>
          {formatBody(c.lastMessage, true)}
        </span>}
        is_unread={c.unreadCount > 0}
        { ...c }
    />
  }

  render() {
    const {
      conversations=[],
      loading=false
    } = this.props

    const unreadCount = conversations.filter(c => c.unreadCount > 0).length

    return (
        <DropdownLink icon='message' count={unreadCount}>
          <div className='dropdown-menu wide'>
            <Scrollbars>
              <ul>
                {conversations.map(this.renderConversation)}
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
