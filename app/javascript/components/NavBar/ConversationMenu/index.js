import React, { Component } from 'react'
import PropTypes from 'prop-types'
import DropdownLink from '../DropdownLink'
import NotificationItem from '../Dropdown/NotificationItem'
import { Link } from 'react-router-dom'
import Scrollbars from 'Shared/Scrollbars'
import subscription from './subscription'
import { formatBody } from 'Chat/ConversationMessage'
import { connect } from 'react-redux'
import { openConversation } from 'actions'

class ConversationMenu extends Component {
  constructor(props) {
    super(props)

    this.renderConversation = this.renderConversation.bind(this)
    this.handleNewConversationClick = this.handleNewConversationClick.bind(this)
  }

  renderConversation(c) {
    const { openConversation } = this.props

    const click = e => {
      e && e.preventDefault && e.preventDefault()
      openConversation(c.guid)
    }

    const user = c.user || {
      name: 'Deleted User',
    }

    return (
      <NotificationItem
        onClick={click}
        key={c.id}
        icon={user.avatar_url}
        created_at={c.lastMessage ? c.lastMessage.created_at : c.created_at}
        title={
          <span>
            <strong>{user.name}</strong>
            <br />
            {formatBody(c.lastMessage, true)}
          </span>
        }
        is_unread={c.unreadCount > 0}
        floatTime
        {...c}
      />
    )
  }

  handleNewConversationClick(e) {
    e.preventDefault()
    this.props.openConversation()
  }

  render() {
    const { conversations = [], loading = false, refetch } = this.props

    const unreadCount = conversations.filter(c => c.unreadCount > 0).length

    const tryRefetch = () => {
      if (refetch) refetch()
    }

    return (
      <DropdownLink icon="message" count={unreadCount} onOpen={tryRefetch}>
        <div className="dropdown-menu wide">
          <div className="title">
            <div className="right">
              <a href={'#'} onClick={this.handleNewConversationClick}>
                New Conversation
              </a>
            </div>
            <strong>Conversations</strong>
          </div>
          <Scrollbars>
            <ul>
              {conversations.map(this.renderConversation)}
              {loading && <li className="empty-item">Loading...</li>}
              {conversations.length > 0 || (
                <li className="empty-item">No new conversations.</li>
              )}
            </ul>
          </Scrollbars>
          {false && (
            <Link to="/conversations" className="cap-link">
              New Conversation
            </Link>
          )}
        </div>
      </DropdownLink>
    )
  }
}

ConversationMenu.propTypes = {
  conversations: PropTypes.array,
}

const mapStateToProps = ({ conversations }, props) => ({
  openConversations: conversations.openConversations,
  ...props,
})

const mapDispatchToProps = {
  openConversation,
}

const connected = connect(mapStateToProps, mapDispatchToProps)(ConversationMenu)

export { connected as ConversationMenu }

export default subscription(connected)
