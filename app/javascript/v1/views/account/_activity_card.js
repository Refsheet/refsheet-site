/* eslint-disable
    no-undef,
    no-unreachable,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ActivityCard; export default ActivityCard = createReactClass({
  propTypes: {
    activityType: PropTypes.string,
    activityMethod: PropTypes.string,
    activityField: PropTypes.string,
    activity: PropTypes.object,
    activities: PropTypes.array,
    user: PropTypes.object.isRequired,
    character: PropTypes.object,
    timestamp: PropTypes.number.isRequired,
  },

  _getIdentity() {
    if (this.props.character) {
      return {
        avatarUrl: this.props.character.profile_image_url,
        name: this.props.character.name,
        link: this.props.character.link,
        is_admin: this.props.user.is_admin,
        is_patron: this.props.user.is_patron,
        username: this.props.user.username,
        type: 'character',
      }
    } else {
      return {
        avatarUrl: this.props.user.avatar_url,
        name: this.props.user.name,
        link: this.props.user.link,
        username: this.props.user.username,
        is_admin: this.props.user.is_admin,
        is_patron: this.props.user.is_patron,
        type: 'user',
      }
    }
  },

  _getActivities() {
    return this.props.activities || [this.props.activity]
  },

  _getActivity() {
    if (!this.props.activity && !this.props.comment) {
      return
    }

    switch (this.props.activityType) {
      case 'Image':
        return (
          <Views.Account.Activities.Image
            images={this._getActivities()}
            character={this.props.character}
          />
        )

      case 'Media::Comment':
        return (
          <Views.Account.Activities.Comment comments={this._getActivities()} />
        )

      case 'Character':
        return (
          <Views.Account.Activities.Character
            characters={this._getActivities()}
            username={this.props.user.username}
          />
        )

      case 'Forum::Discussion':
        return (
          <Views.Account.Activities.ForumDiscussion
            discussions={this._getActivities()}
          />
        )

      default:
        if (this.props.comment) {
          return (
            <Views.Account.Activities.StatusUpdate
              comment={this.props.comment}
            />
          )
        } else {
          return (
            <div className="red-text padding-bottom--medium">
              Unsupported activity type: {this.props.activityType}.
              {this.props.activityMethod}
            </div>
          )
        }
    }
  },

  render() {
    let imgShadow, nameColor
    return <ActivityCard {...this.props} />

    const { date, dateHuman } = this.props
    const identity = this._getIdentity()

    if (identity.is_admin) {
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'
    } else if (identity.is_patron) {
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'
    }

    return (
      <div className="card sp with-avatar margin-bottom--medium">
        <img
          className="avatar circle"
          src={identity.avatarUrl}
          alt={identity.name}
          style={{ boxShadow: imgShadow }}
        />

        <div className="card-content padding-bottom--medium">
          <IdentityLink to={identity} /> uploaded four images
          <div className="date">
            <DateFormat
              className="muted"
              timestamp={this.props.timestamp}
              fuzzy
            />
          </div>
        </div>

        {this._getActivity()}

        <div className="clearfix" />
      </div>
    )
  },
})
