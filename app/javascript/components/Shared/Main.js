import React, { Component } from 'react'
import PropTypes from 'prop-types'
import WindowAlert from 'WindowAlert'
import styled from 'styled-components'
import c from 'classnames'
import { buildShadow } from '../Styled/common'

class _Main extends Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    if (this.props.title) {
      WindowAlert.addNow('main', this.props.title)
    }

    if (this.props.bodyClassName) {
      document.body.addClass(this.props.bodyClassName)
    }
  }

  componentDidUpdate(prevProps) {
    if (prevProps.title !== this.props.title) {
      WindowAlert.addNow('main', this.props.title)
    }

    if (prevProps.bodyClassName !== this.props.bodyClassName) {
      document.body.removeClass(prevProps.bodyClassName)
      document.body.addClass(this.props.bodyClassName)
    }
  }

  componentWillUnmount() {
    if (this.props.bodyClassName) {
      document.body.removeClass(this.props.bodyClassName)
    }
  }

  render() {
    const style = this.props.style || {}

    if (this.props.fadeEffect || this.props.slideEffect) {
      // TODO: Animations on Main are disabled.
      style.display = 'block'
    }

    return (
      <main
        style={style}
        id={this.props.id}
        className={c('z-depth-1', this.props.className, {
          'main-flex': this.props.flex,
        })}
      >
        {this.props.children}
      </main>
    )
  }
}

const Main = styled(_Main)`
  color: ${props => props.theme.text};
  background-color: ${props => props.theme.background};
  box-shadow: ${props => buildShadow(props.theme.cardShadow, 2)} !important;

  &.main-flex {
    &.split-bg-right {
      background: linear-gradient(
        to right,
        ${props => props.theme.background} 50%,
        ${props => props.theme.cardBackground} 50%
      );
    }

    &.split-bg-left,
    &.with-sidebar {
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

_Main.propTypes = {
  style: PropTypes.object,
  className: PropTypes.string,
  bodyClassName: PropTypes.string,
  flex: PropTypes.bool,
  fadeEffect: PropTypes.bool,
  slideEffect: PropTypes.bool,
  children: PropTypes.node,
  id: PropTypes.string,
  title: PropTypes.oneOfType([PropTypes.string, PropTypes.array]),
}

export default Main
