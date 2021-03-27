import React from 'react'
import PropTypes from 'prop-types'
import Modal from '../../../Styled/Modal'
import { withTranslation } from 'react-i18next'

const MarketplaceBuyModal = ({ character, onClose, t }) => {
  return (
    <div>
      <Modal
        autoOpen
        id="marketplace-buy"
        title={t('labels.buy_from_marketplace', 'Buy From Marketplace')}
        onClose={onClose}
      >
        Buy me? owo
      </Modal>
    </div>
  )
}

MarketplaceBuyModal.propTypes = {
  character: PropTypes.object,
  onClose: PropTypes.func,
  t: PropTypes.func,
}

export default withTranslation('common')(MarketplaceBuyModal)
