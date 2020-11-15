import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import { Link } from 'react-router-dom'
import Icon from 'v1/shared/material/Icon'
import * as ReactRouter from 'react-router'
import { withRouter } from 'react-router'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const NavLink = createReactClass({
  propTypes: {
    to: PropTypes.string.isRequired,
    text: PropTypes.string.isRequired,
    icon: PropTypes.string,
    disabled: PropTypes.bool,
    className: PropTypes.string,
    activeClassName: PropTypes.string,
  },

  render() {
    let active, currentPath
    let { to } = this.props

    if (to[0] === '?') {
      to = '/' + to
    }

    if (this.props.noStrict) {
      currentPath = this.props.match.path
      active = currentPath.indexOf(to) === 0
    } else if (to.match(/\?/)) {
      currentPath =
        this.props.location.pathname + (this.props.location.search || '')
    } else {
      currentPath = this.props.location.pathname
    }

    if (!this.props.noStrict) {
      active = ReactRouter.matchPath(to, {
        path: currentPath,
        exact: true,
      })
    }

    if (this.props.disabled) {
      to = ''
    }

    const classNames = ['nav-link']
    if (this.props.className) {
      classNames.push(this.props.className)
    }
    if (active) {
      classNames.push('active')
    }
    if (this.props.disabled) {
      classNames.push('disabled')
    }

    const linkClassNames = []
    if (this.props.disabled) {
      linkClassNames.push('disabled')
    }

    const activeClassNames = ['active current']
    if (this.props.activeClassName) {
      activeClassNames.push(this.props.activeClassName)
    }

    if (active) {
      linkClassNames.push(activeClassNames)
    }

    return (
      <li className={classNames.join(' ')}>
        <Link to={to} className={linkClassNames.join(' ')}>
          {this.props.icon && <Icon className="left">{this.props.icon}</Icon>}{' '}
          {this.props.text}
        </Link>

        {!this.props.disabled && active && this.props.children && (
          <ul className="subnav">{this.props.children}</ul>
        )}
      </li>
    )
  },
})

export default withRouter(NavLink)
