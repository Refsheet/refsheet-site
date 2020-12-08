import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import compose from 'utils/compose'
import { Tab } from 'react-materialize'
import Tabs from '../../../Styled/Tabs'
import Modal from '../../../Styled/Modal'
import UploadCover from './UploadCover'

/**
 * TODO: Remove code duplication in this class and AvatarModal.
 */
class CoverModal extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    const { t, onClose, onSave, character } = this.props

    return (
      <Modal
        autoOpen
        id="upload-cover"
        title={t('labels.change_cover_image', 'Change Cover Image')}
        onClose={onClose}
      >
        <Tabs className={'modal-tabs'}>
          <Tab id={'upload-cover_upload'} title={'Upload File'} active>
            <UploadCover
              character={character}
              onSave={onSave}
              onClose={onClose}
            />
          </Tab>
          <Tab id={'upload-cover_gallery'} title={'Pick from Gallery'}></Tab>
        </Tabs>
      </Modal>
    )
  }
}

CoverModal.propTypes = {
  character: PropTypes.object.isRequired,
  onSave: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
}

export default compose(
  withTranslation('common')
  // TODO: Add HOC bindings here
)(CoverModal)
