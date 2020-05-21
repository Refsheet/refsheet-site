import React, { Component } from 'react'
import PropTypes from 'prop-types'
import c from 'classnames'
import { format as f } from 'NumberUtils'
import { Icon } from 'react-materialize'

class DropdownLink extends Component {
  constructor(props) {
    super(props)

    this.ref = null

    this.state = {
      visible: false,
    }

    this.handleMenuToggle = this.handleMenuToggle.bind(this)
    this.handleBodyClick = this.handleBodyClick.bind(this)
  }

  componentDidMount() {
    document.body.addEventListener('click', this.handleBodyClick)
  }

  componentWillUnmount() {
    document.body.removeEventListener('click', this.handleBodyClick)
  }

  handleBodyClick(e) {
    if (!this.ref || this.ref.contains(e.target)) return null
    this.setState({ visible: false })
  }

  handleMenuToggle(e) {
    e.preventDefault()
    this.props.onClick && this.props.onClick()
    const visible = !this.state.visible
    this.setState({ visible }, () => {
      if (visible && this.props.onOpen) {
        this.props.onOpen()
      }
    })
  }

  render() {
    const { imageSrc, className, text = '?', icon, count } = this.props

    const { visible } = this.state

    const classNames = c('dropdown-trigger-native', className, {
      avatar: !!imageSrc,
      active: visible,
    })

    return (
      <li ref={r => (this.ref = r)}>
        <a
          className={classNames}
          onClick={this.handleMenuToggle}
          data-testid={this.props['data-testid']}
        >
          {imageSrc ? (
            <img src={imageSrc} className="circle" />
          ) : icon ? (
            <Icon>{icon}</Icon>
          ) : (
            <span>{text}</span>
          )}

          {!!count && count > 0 && <span className="count">{f(count)}</span>}
        </a>

        {visible && this.props.children}
      </li>
    )
  }
}

DropdownLink.propTypes = {
  onOpen: PropTypes.func,
}

export default DropdownLink
