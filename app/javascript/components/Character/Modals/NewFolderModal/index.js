import React from 'react'
import PropTypes from 'prop-types'
import Modal from '../../../Styled/Modal'
import { withTranslation } from 'react-i18next'

const NewFolderModal = ({ character, onClose, t }) => {
  return (
    <div>
      <Modal
        autoOpen
        id="new-media-folder"
        title={t('labels.new_media_folder', 'New Media Folder')}
        onClose={onClose}
      >
        Patience, my friend. We're almost here. I Pwomise.
      </Modal>
    </div>
  )
}

NewFolderModal.propTypes = {
  character: PropTypes.object,
  onClose: PropTypes.func,
  t: PropTypes.func,
}

export default withTranslation('common')(NewFolderModal)
