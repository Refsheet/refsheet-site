import React, { Component } from 'react'
import * as M from 'materialize-css'

class Tabs extends Component {
  constructor(props) {
    super(props)

    this.tabRef = null
  }

  componentDidMount() {
    M.Tabs.init(this.tabRef, {
      onShow: this.handleTabShow.bind(this),
    })
  }

  componentWillUnmount() {
    const instance = M.Tabs.getInstance(this.tabRef)
    if (instance) instance.destroy()
  }

  handleTabShow(data) {
    console.log(data)
    const { onChange } = this.props
    onChange && onChange(data.id)
  }

  render() {
    const { children } = this.props

    return (
      <React.Fragment>
        <ul className={'tabs'} ref={r => (this.tabRef = r)}>
          {React.Children.map(children, child => {
            const { id, title } = child.props
            return (
              <li className={'tab'}>
                <a href={`#${id}`}>{title}</a>
              </li>
            )
          })}
        </ul>
        {children}
      </React.Fragment>
    )
  }
}

import Tab from './Tab'
export { Tab }
export default Tabs
