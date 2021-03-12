import React, { Component } from 'react'
import PropTypes from 'prop-types'
import EditCharacter from './EditCharacter'
import TransferCharacter from './TransferCharacter'
import { withTranslation } from 'react-i18next'
import compose from '../../../../utils/compose'
import DeleteCharacter from './DeleteCharacter'

import Modal from 'Styled/Modal'
import Tabs, { Tab } from '../../../Styled/Tabs'
import DataLink from './DataLink'
import MarketplaceListing from './MarketplaceListing'
import Restrict from '../../../Shared/Restrict'

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

  goToTab(view) {
    console.log({ view })
    this.setState({ view })
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
      case 'dataLink':
        return (
          <DataLink
            character={this.props.character}
            onSave={this.props.refetch}
            goTo={this.goTo.bind(this)}
          />
        )
      case 'marketplace':
        return (
          <MarketplaceListing
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
            onClose={this.props.onClose}
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
        <Tabs onChange={this.goToTab.bind(this)}>
          <Tab id={'settings'} title={'Settings'} />
          <Tab id={'dataLink'} title={'Data Link'} />
          <Tab id={'marketplace'} title={'Marketplace'} />
        </Tabs>

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

export default compose(withTranslation('common'))(SettingsModal)
