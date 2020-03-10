import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let DateFormat
export default DateFormat = createReactClass({
  propTypes: {
    timestamp: PropTypes.number.isRequired,
    fuzzy: PropTypes.bool,
    dateOnly: PropTypes.bool,
    short: PropTypes.bool,
    className: PropTypes.string,
  },

  getInitialState() {
    return {
      timer: null,
      dateDisplay: null,
    }
  },

  UNSAFE_componentWillMount() {
    return this._initialize()
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    return this._initialize(newProps)
  },

  componentWillUnmount() {
    if (this.state.timer) {
      return clearTimeout(this.state.timer)
    }
  },

  _initialize(props) {
    if (props == null) {
      ;({ props } = this)
    }
    if (this.state.timer) {
      clearTimeout(this.state.timer)
    }

    if (props.fuzzy) {
      const t = setTimeout(
        this._fuzzyPoll,
        (60 - this.date().getSeconds()) * 1000
      )
      return this.setState({ dateDisplay: this.fuzzyDate(), timer: t })
    } else {
      return this.setState({ dateDisplay: this.showDate() })
    }
  },

  _fuzzyPoll() {
    const t = setTimeout(this._fuzzyPoll, 60000)
    return this.setState({ dateDisplay: this.fuzzyDate(), timer: t })
  },

  _z(n) {
    if (n < 10) {
      return '0' + n
    } else {
      return n
    }
  },

  _p(i, word) {
    if (this.props.short && word.substring(0, 2) === 'mo') {
      return `${i}mo`
    }
    if (this.props.short) {
      return `${i}${word.substring(0, 1)}`
    }

    const s = i === 1 ? '' : 's'
    return `${i} ${word}${s}`
  },

  monthNames: [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ],

  date() {
    let ts = parseInt(this.props.timestamp)
    if (ts < Math.pow(10, 11)) {
      ts *= 1000
    }
    return new Date(ts)
  },

  fullTime() {
    const date = this.date()
    return `${date.getFullYear()}-${this._z(date.getMonth() + 1)}-${this._z(
      date.getDate()
    )} ${this._z(date.getHours())}:${this._z(date.getMinutes())}:${this._z(
      date.getSeconds()
    )}`
  },

  showDate() {
    const date = this.date()
    let month = this.monthNames[date.getMonth()]
    if (this.props.short) {
      month = month.substr(0, 3)
    }

    let hour = date.getHours() % 12
    if (hour === 0) {
      hour = 12
    }
    const apm = hour >= 12 ? 'pm' : 'am'

    let end = `${month} ${date.getDate()}, ${date.getYear()}`
    if (!this.props.dateOnly) {
      end += ` ${this._z(hour)}:${this._z(date.getMinutes())} ${apm}`
    }
    return end
  },

  fuzzyDate() {
    const msPerMinute = 60 * 1000
    const msPerHour = msPerMinute * 60
    const msPerDay = msPerHour * 24
    const msPerMonth = msPerDay * 30
    const msPerYear = msPerDay * 365

    const elapsed = new Date().getTime() - this.date().getTime()
    const ago = this.props.short ? '' : ' ago'
    const about = this.props.short ? '' : 'about '

    switch (false) {
      case !(elapsed < msPerMinute):
        if (this.props.short) {
          return '<1m'
        } else {
          return 'recently'
        }
      case !(elapsed < msPerHour):
        return `${this._p(Math.round(elapsed / msPerMinute), 'minute')}${ago}`
      case !(elapsed < msPerDay):
        return `${this._p(Math.round(elapsed / msPerHour), 'hour')}${ago}`
      case !(elapsed < msPerMonth):
        return `${about}${this._p(Math.round(elapsed / msPerDay), 'day')}${ago}`
      case !(elapsed < msPerYear):
        return `${about}${this._p(
          Math.round(elapsed / msPerMonth),
          'month'
        )}${ago}`
      default:
        return `${about}${this._p(
          Math.round(elapsed / msPerYear),
          'year'
        )}${ago}`
    }
  },

  render() {
    if (!this.props.timestamp) {
      return null
    }

    return (
      <span className={this.props.className} title={this.fullTime()}>
        {this.state.dateDisplay}
      </span>
    )
  },
})
