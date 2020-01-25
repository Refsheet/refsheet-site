/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React, { Component } from 'react'
import PropTypes from 'prop-types'
import WindowAlert from 'WindowAlert'
import styled from 'styled-components'

class _Main extends Component {
  constructor(props) {
    super(props)
  }

  componentWillMount() {
    if (this.props.title) {
      return WindowAlert.addNow('main', this.props.title)
    }
  }

  //    document.body.addClass @props.bodyClassName

  componentWillReceiveProps(newProps) {
    if (newProps.title) {
      return WindowAlert.addNow('main', this.props.title)
    }
  }

  //    if newProps.bodyClassName != @props.bodyClassName
  //      document.body.removeClass @props.bodyClassName
  //      document.body.addClass newProps.bodyClassName
  //
  //  componentWillUnmount: ->
  //    document.body.removeClass @props.bodyClassName

  render() {
    const style = this.props.style || {}
    const classNames = [this.props.className]
    if (this.props.flex) {
      classNames.push('main-flex')
    }

    return (
      <main style={style} id={this.props.id} className={classNames.join(' ')}>
        {this.props.children}
      </main>
    )
  }
}

const Main = styled(_Main)`
  color: ${props => props.theme.text};
  background-color: ${props => props.theme.background};

  &.main-flex {
    &.split-bg-right {
      background: linear-gradient(
        to right,
        ${props => props.theme.background} 50%,
        ${props => props.theme.cardBackground} 50%
      );
    }

    &.split-bg-left {
      background: linear-gradient(
        to left,
        ${props => props.theme.background} 50%,
        ${props => props.theme.cardBackground} 50%
      );
    }

    .container.container-flex {
      .content,
      .content-left {
        background-color: ${props => props.theme.background};
      }

      .sidebar {
        background-color: ${props => props.theme.cardBackground};
      }
    }
  }
`

Main.propTypes = {
  style: PropTypes.object,
  className: PropTypes.string,
  bodyClassName: PropTypes.string,
  id: PropTypes.string,
  title: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
}

export default Main
