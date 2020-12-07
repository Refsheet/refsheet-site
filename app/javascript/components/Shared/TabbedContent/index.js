import React, { Component } from 'react'
import M from 'materialize-css'
import PropTypes from 'prop-types'

class TabbedContent extends Component {
  constructor(props) {
    super(props)

    this.tabs = null

    this.state = {
      activeTab: null,
    }
  }

  componentDidMount() {
    this.tabs && M.Tabs.init(this.tabs)
  }

  render() {
    return (
      <div className="tab-row-container">
        <div className="tab-row pushpin">
          <div className="container">
            <ul className={'tabs'} ref={r => (this.tabs = r)}>
              <li className={true ? 'active tab' : 'tab'}>
                <a className={true ? 'active' : ''} href="#commission-info">
                  Profile
                </a>
              </li>
              <li className={false ? 'active tab' : 'tab'}>
                <a className={false ? 'active' : ''} href="#commission-info">
                  Gallery
                </a>
              </li>
              <li className={false ? 'active tab' : 'tab'}>
                <a className={false ? 'active' : ''} href="#commission-info">
                  Commission Info
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    )
  }
}

TabbedContent.propTypes = {}

export default TabbedContent
