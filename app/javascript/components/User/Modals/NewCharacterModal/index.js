import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import compose from 'utils/compose'
import Modal from '../../../Styled/Modal'
import { withCurrentUser } from '../../../../utils/compose'
import NewCharacterForm from '../../../../v1/views/characters/NewCharacterForm'
import { connect } from 'react-redux'
import { closeNewCharacterModal } from '../../../../actions'
import { withRouter } from 'react-router'
import Flash from '../../../../utils/Flash'

class NewCharacterModal extends Component {
  constructor(props) {
    super(props)
  }

  handleCreate(data) {
    const { t, history, closeNewCharacterModal } = this.props
    const { link } = data
    Flash.info(t('flash.character_created', 'Character created!'))
    closeNewCharacterModal()
    history.push(link)
  }

  render() {
    const { t, open, closeNewCharacterModal, currentUser } = this.props
    if (!open || !currentUser) return null

    return (
      <Modal
        autoOpen
        id="new-character"
        title={t('labels.new_character', 'New Character')}
        onClose={closeNewCharacterModal}
      >
        <NewCharacterForm
          newCharacterPath={`/users/${currentUser.username}/characters`}
          onCreate={this.handleCreate.bind(this)}
        />
      </Modal>
    )
  }
}

NewCharacterModal.propTypes = {
  t: PropTypes.func.isRequired,
  open: PropTypes.bool,
  closeNewCharacterModal: PropTypes.func.isRequired,
  history: PropTypes.object.isRequired,
  currentUser: PropTypes.object,
}

const mapStateToProps = ({ modals: { newCharacter } }, props) => ({
  ...props,
  open: newCharacter.open,
})

const mapDispatchToProps = {
  closeNewCharacterModal,
}

export default compose(
  withTranslation('common'),
  connect(mapStateToProps, mapDispatchToProps),
  withCurrentUser(),
  withRouter
)(NewCharacterModal)
