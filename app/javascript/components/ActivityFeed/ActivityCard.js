import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withNamespaces } from 'react-i18next'
import Moment from 'react-moment'
import UserAvatar from '../User/UserAvatar'
import UserLink from '../User/UserLink'
import * as Activities from './Activities'
import {
  characterIdentitySourceType,
  userIdentitySourceType,
} from '../../utils/IdentityUtils'

class ActivityCard extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    const { t, user, character, timestamp } = this.props

    const activityText = Activities.getText(t, this.props)

    return (
      <div className="card sp with-avatar margin-bottom--medium">
        <UserAvatar user={user} character={character} />

        <div className="card-content padding-bottom--none">
          <UserLink user={user} character={character} /> {activityText}
          <div className="date">
            <Moment className="muted" unix fromNow>
              {timestamp}
            </Moment>
          </div>
        </div>

        {Activities.render(this.props)}

        <div className="clearfix" />
      </div>
    )
  }
}

ActivityCard.propTypes = {
  user: PropTypes.shape(userIdentitySourceType).isRequired,
  timestamp: PropTypes.number.isRequired,
  character: PropTypes.shape(characterIdentitySourceType),
  activityText: PropTypes.string,
}

export default withNamespaces('common')(ActivityCard)
