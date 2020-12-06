import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Spinner from '../../../shared/material/Spinner'
import Icon from '../../../shared/material/Icon'
import InfiniteScroll from '../../../shared/InfiniteScroll'
import Views from '../../../views/_views'
import $ from 'jquery'
import StateUtils from '../../../utils/StateUtils'
import Model from '../../../utils/Model'
import HashUtils from '../../../utils/HashUtils'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS101: Remove unnecessary use of Array.from
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

let Feed
export default Feed = createReactClass({
  propTypes: {
    filter: PropTypes.string,
  },

  timer: null,
  dataPath: '/notifications',
  stateLink() {
    return {
      dataPath:
        '/notifications?filter=' +
        this.props.filter +
        '&before=' +
        this.state.since,
      statePath: 'notifications',
    }
  },

  getInitialState() {
    return {
      notifications: null,
      newActivity: null,
      since: null,
      timer: null,
      lastUpdate: null,
    }
  },

  componentDidMount() {
    return StateUtils.load(
      this,
      'notifications',
      this.props.match != null ? this.props.match.params : undefined,
      () => {
        this.setState({
          since:
            this.state.notifications[0] != null
              ? this.state.notifications[0].timestamp
              : undefined,
          lastUpdate: Math.floor(Date.now() / 1000),
        })
        return this._poll()
      },
      { urlParams: { filter: this.props.filter } }
    )
  },

  componentWillUnmount() {
    if (this.timer) {
      return clearTimeout(this.timer)
    }
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (this.props.filter !== newProps.filter) {
      if (this.timer) {
        clearTimeout(this.timer)
      }
      return this.setState({ notifications: null }, () => {
        return StateUtils.load(
          this,
          'notifications',
          newProps.match != null ? newProps.match.params : undefined,
          () => {
            this.setState({
              since:
                this.state.notifications[0] != null
                  ? this.state.notifications[0].timestamp
                  : undefined,
              lastUpdate: Math.floor(Date.now() / 1000),
            })
            return this._poll()
          },
          { urlParams: { filter: this.props.filter } }
        )
      })
    }
  },

  UNSAFE_componentWillUpdate(newProps, newState) {
    if (newState.newActivity !== this.state.newActivity) {
      document.title = document.title.replace(/^\(\d+\)\s+/, '')
      if (newState.newActivity && newState.newActivity.length > 0) {
        return (document.title =
          `(${newState.newActivity.length}) ` + document.title)
      }
    }
  },

  _poll() {
    return (this.timer = setTimeout(() => {
      return Model.poll(
        this.dataPath,
        { since: this.state.since, filter: this.props.filter },
        data => {
          return this.setState(
            {
              newActivity: data.notifications,
              lastUpdate: Math.floor(Date.now() / 1000),
            },
            this._poll
          )
        }
      )
    }, 15000))
  },

  _prepend() {
    const act = (this.state.newActivity || []).concat(this.state.notifications)
    return this.setState({
      notifications: act,
      since: act[0] != null ? act[0].timestamp : undefined,
      newActivity: null,
    })
  },

  _append(notifications) {
    return StateUtils.updateItems(this, 'notifications', notifications)
  },

  _groupedActivity() {
    const grouped = []

    for (let item of Array.from(this.state.notifications)) {
      const last = grouped[grouped.length - 1]

      if (
        item.notification &&
        last &&
        HashUtils.compare(
          item,
          last,
          'user.username',
          'character.id',
          'notifications_type',
          'notifications_method'
        ) &&
        last.timestamp - item.timestamp < 3600
      ) {
        if (!last.notifications) {
          last.notifications = [last.notifications]
        }
        if (
          !HashUtils.itemExists(last.notifications, item.notifications, 'id')
        ) {
          last.notifications.push(item.notifications)
        }
      } else {
        grouped.push(item)
      }
    }

    return grouped
  },

  _markRead(read, path) {
    return e => {
      e.preventDefault()
      return Model.put(path, { read }, data => {
        return StateUtils.updateItem(this, 'notifications', data, 'id')
      })
    }
  },

  _markAllRead(read) {
    return e => {
      e.preventDefault()
      const ids = this.state.notifications.map(n => n.id)

      return Model.put('/notifications/bulk_update', { read, ids }, data => {
        const newNotes = this.state.notifications.map(function (n) {
          const note = $.extend({}, n)
          note.is_read = data.read
          return note
        })
        return this.setState({ notifications: newNotes })
      })
    }
  },

  render() {
    if (!this.state.notifications) {
      return <Spinner className="margin-top--large" small center />
    }
    const __this = this

    const out = this._groupedActivity().map(item => (
      <Views.Account.Notifications.Card
        {...item}
        key={item.id}
        onReadChange={__this._markRead}
      />
    ))

    return (
      <div className="feed-item-stream">
        <div className="feed-header margin-bottom--medium">
          <a
            className="btn btn-flat right muted low-pad"
            onClick={this._markAllRead(true)}
          >
            Read All
            <Icon className="right">done_all</Icon>
          </a>

          {this.state.newActivity && this.state.newActivity.length > 0 && (
            <a className="btn btn-flat" onClick={this._prepend}>
              {this.state.newActivity.length} new{' '}
              {this.state.newActivity.length == 1
                ? 'notification'
                : 'notifications'}
            </a>
          )}

          <br className="clearfix" />
        </div>

        {out}

        <InfiniteScroll
          onLoad={this._append}
          stateLink={this.stateLink}
          params={{}}
          count={this.state.notifications.length}
        />
      </div>
    )
  },
})
