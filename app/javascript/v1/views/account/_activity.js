/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Spinner from '../../shared/material/Spinner'
import StringUtils from '../../../utils/StringUtils'
import Restrict from '../../../components/Shared/Restrict'
import CommentForm from '../../../components/Shared/CommentForm'
import InfiniteScroll from '../../shared/InfiniteScroll'
import Views from 'v1/views/_views'
import StateUtils from "../../utils/StateUtils"
import Model from "../../utils/Model"
import HashUtils from 'v1/utils/HashUtils'
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
let Activity
export default Activity = createReactClass({
  contextTypes: {
    currentUser: PropTypes.object,
  },

  propTypes: {
    filter: PropTypes.string,
  },

  timer: null,
  dataPath: '/account/activity',
  stateLink() {
    return {
      dataPath:
        '/account/activity?filter=' +
        this.props.filter +
        '&before=' +
        this.state.since,
      statePath: 'activity',
    }
  },

  getInitialState() {
    return {
      activity: null,
      newActivity: null,
      since: null,
      timer: null,
      lastUpdate: null,
    }
  },

  componentDidMount() {
    return StateUtils.load(
      this,
      'activity',
      this.props.match != null ? this.props.match.params : undefined,
      () => {
        this.setState({
          since:
            this.state.activity[0] != null
              ? this.state.activity[0].timestamp
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
      return this.setState({ activity: null }, () => {
        return StateUtils.load(
          this,
          'activity',
          newProps.match != null ? newProps.match.params : undefined,
          () => {
            this.setState({
              since:
                this.state.activity[0] != null
                  ? this.state.activity[0].timestamp
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
              newActivity: data.activity,
              lastUpdate: Math.floor(Date.now() / 1000),
            },
            this._poll
          )
        }
      )
    }, 15000))
  },

  _prepend() {
    const act = (this.state.newActivity || []).concat(this.state.activity)
    return this.setState({
      activity: act,
      since: act[0] != null ? act[0].timestamp : undefined,
      newActivity: null,
    })
  },

  _append(activity) {
    return StateUtils.updateItems(this, 'activity', activity)
  },

  _groupedActivity() {
    const grouped = []

    for (let item of Array.from(this.state.activity)) {
      const last = grouped[grouped.length - 1]

      if (
        item.activity &&
        last &&
        HashUtils.compare(
          item,
          last,
          'user.username',
          'character.id',
          'activity_type',
          'activity_method'
        ) &&
        last.timestamp - item.timestamp < 3600
      ) {
        if (!last.activities) {
          last.activities = [last.activity]
        }
        if (!HashUtils.itemExists(last.activities, item.activity, 'id')) {
          last.activities.push(item.activity)
        }
      } else {
        grouped.push(item)
      }
    }

    return grouped
  },

  render() {
    if (!this.state.activity) {
      return <Spinner className="margin-top--large" small center />
    }

    const out = this._groupedActivity().map(item => (
      <Views.Account.ActivityCard
        {...StringUtils.camelizeKeys(item)}
        key={item.id}
      />
    ))

    return (
      <div className="feed-item-stream">
        <Restrict patron>
          <CommentForm />
        </Restrict>

        {this.state.newActivity && this.state.newActivity.length > 0 && (
          <a
            className="btn btn-flat block margin-bottom--medium"
            onClick={this._prepend}
          >
            {this.state.newActivity.length} new{' '}
            {this.state.newActivity.length == 1 ? 'activity' : 'activities'}
          </a>
        )}

        {out}

        <InfiniteScroll
          onLoad={this._append}
          stateLink={this.stateLink}
          params={{}}
          count={this.state.activity.length}
        />
      </div>
    )
  },
})
