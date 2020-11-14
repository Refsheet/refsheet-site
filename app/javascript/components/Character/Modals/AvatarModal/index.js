import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import compose from 'utils/compose'
import { Tab } from 'react-materialize'
import Tabs from '../../../Styled/Tabs'
import Modal from '../../../Styled/Modal'
import UploadAvatar from './UploadAvatar'

class AvatarModal extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    const { t, onClose, onSave, character } = this.props

    return (
      <Modal
        autoOpen
        id="upload-avatar"
        title={t('labels.change_profile_image', 'Change Profile Image')}
        onClose={onClose}
      >
        <Tabs className={'modal-tabs'}>
          <Tab id={'upload-avatar_upload'} title={'Upload File'} active>
            <UploadAvatar
              character={character}
              onSave={onSave}
              onClose={onClose}
            />
          </Tab>
          <Tab id={'upload-avatar_upload'} title={'Pick from Gallery'}></Tab>
        </Tabs>
      </Modal>
    )
  }
}

AvatarModal.propTypes = {
  character: PropTypes.object.isRequired,
  onSave: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
}

export default compose(
  withTranslation('common')
  // TODO: Add HOC bindings here
)(AvatarModal)
