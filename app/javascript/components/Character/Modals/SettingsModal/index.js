import React, { Component } from 'react'
import PropTypes from 'prop-types'
import EditCharacter from './EditCharacter'
import TransferCharacter from './TransferCharacter'
import { withNamespaces } from 'react-i18next'
import compose from '../../../../utils/compose'
import DeleteCharacter from './DeleteCharacter'

import Modal from 'v1/shared/Modal'

class SettingsModal extends Component {
  constructor(props) {
    super(props)

    this.state = {
      view: 'settings',
    }
  }

  goTo(view) {
    return e => {
      if (e) e.preventDefault()
      this.setState({ view })
    }
  }

  getTitle() {
    const { t } = this.props
    const { view } = this.state
    return t(`character.settings.title_${view}`, `Character ${view}`)
  }

  renderContent() {
    switch (this.state.view) {
      case 'transfer':
        return (
          <TransferCharacter
            character={this.props.character}
            onSave={this.props.refetch}
            goTo={this.goTo.bind(this)}
          />
        )
      case 'delete':
        return (
          <DeleteCharacter
            character={this.props.character}
            onSave={this.props.refetch}
            goTo={this.goTo.bind(this)}
          />
        )
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
        title={this.getTitle()}
        onClose={this.props.onClose}
      >
        {this.renderContent()}
      </Modal>
    )
  }
}

SettingsModal.propTypes = {
  character: PropTypes.object.isRequired,
  onClose: PropTypes.func,
  refetch: PropTypes.func,
}

export default compose(withNamespaces('common'))(SettingsModal)
