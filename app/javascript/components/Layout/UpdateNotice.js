import React, { Component } from 'react'
import { host } from 'services/ApplicationService'
import compose from '../../utils/compose'
import { withTranslation } from 'react-i18next'

class UpdateNotice extends Component {
  constructor(props) {
    super(props)

    this.state = {
      updateAvailable: false,
    }

    this.updateInterval = null
  }

  componentDidMount() {
    // Check for updates every 5 minutes
    this.updateInterval = setInterval(
      this.checkForUpdates.bind(this),
      5 * 60 * 1000
    )
    this.checkForUpdates()
  }

  checkForUpdates() {
    const _this = this
    fetch(host + '/health.json')
      .then(response => response.json())
      .then(data => {
        console.log('Version is: ' + data.version)
        if (data.version !== window.Refsheet.version) {
          console.log('Update is available!')
          _this.setState({ updateAvailable: true })
        }
      })
      .catch(console.error)
  }

  render() {
    if (this.state.updateAvailable) {
      return (
        <div
          className={'update-notice card-panel cyan darken-4 white-text'}
          style={{ position: 'fixed', bottom: '1rem', left: '1rem' }}
        >
          {this.props.t(
            'system.update_available',
            'An update is available. Please save any work and then reload your browser.'
          )}
        </div>
      )
    } else {
      return null
    }
  }
}

export default compose(withTranslation('common'))(UpdateNotice)
