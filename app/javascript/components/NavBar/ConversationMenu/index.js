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
  }

  renderConversation(c) {
    const {
      openConversation
    } = this.props

    const click = (e) => {
      e.preventDefault()
      openConversation(c.guid)
    }

    return <NotificationItem
        onClick={ click }
        key={ c.id }
        icon={c.user.avatar_url}
        created_at={c.lastMessage ? c.lastMessage.created_at : c.created_at}
        title={<span>
          <strong>{c.user.name}</strong><br/>
          {formatBody(c.lastMessage, true)}
        </span>}
        is_unread={c.unreadCount > 0}
        floatTime
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
            <div className='title'>
              <div className='right'>
                <a href={'#'}>Mark All Read</a>
              </div>
              <strong>Conversations</strong>
            </div>
            <Scrollbars>
              <ul>
                {conversations.map(this.renderConversation)}
                {loading && <li className='empty-item'>Loading...</li>}
                {conversations.length > 0 || <li className='empty-item'>No new conversations.</li>}
              </ul>
            </Scrollbars>
            {conversations.length > 0 &&
              <Link to='/conversations' className='cap-link'>
                New Conversation
              </Link>
            }
          </div>
        </DropdownLink>
    )
  }
}

ConversationMenu.propTypes = {
  conversations: PropTypes.array
}

const mapStateToProps = ({conversations}, props) => ({
  openConversations: conversations.openConversations,
  ...props
})

const mapDispatchToProps = {
  openConversation
}

const connected = connect(mapStateToProps, mapDispatchToProps)(ConversationMenu)

export { connected as ConversationMenu }

export default subscription(connected)
