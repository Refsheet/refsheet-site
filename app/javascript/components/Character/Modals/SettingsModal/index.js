import React, { Component } from 'react'
import PropTypes from 'prop-types'
import EditCharacter from './EditCharacter'

class SettingsModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      view: 'settings',
    }
  }

  goTo(view) {
    this.setState({ view })
  }

  renderContent() {
    switch (this.state.view) {
      case 'transfer':
        return <p>Transfer</p>
      case 'delete':
        return <p>Delete</p>
      default:
        return (
          <EditCharacter
            character={this.props.character}
            onSave={this.props.refetch}
            goTo={this.goTo.bind(this)}
          />
        )
    }
  }

  render() {
    return (
      <Modal
        autoOpen
        id="character-settings"
        title={'Character Settings'}
        onClose={this.props.onClose}
      >
        {this.renderContent()}
      </Modal>
    )
  }
}

SettingsModal.propTypes = {
  onClose: PropTypes.func,
}

export default SettingsModal
