import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import compose, { withCurrentUser } from 'utils/compose'
import { withTranslation } from 'react-i18next'
import Modal from '../Styled/Modal'
import { closeSupportModal } from '../../actions'

class SupportModal extends Component {
  handleClose() {
    this.props.closeSupportModal()
  }

  render() {
    const { open, currentUser, t } = this.props

    if (!open) {
      return null
    }

    return (
      <Modal
        autoOpen
        onClose={this.handleClose.bind(this)}
        title={t('SupportModal.title', 'Change Supporter Status')}
      >
        {currentUser.username}
      </Modal>
    )
  }
}

SupportModal.propTypes = {
  t: PropTypes.func.isRequired,
  open: PropTypes.bool,
  currentUser: PropTypes.shape({
    username: PropTypes.string,
  }),
}

const mapStateToProps = ({ modals: { support } }, props) => ({
  ...props,
  ...support,
})

const mapDispatchToProps = {
  closeSupportModal,
}

export default compose(
  connect(mapStateToProps, mapDispatchToProps),
  withTranslation('common'),
  withCurrentUser()
)(SupportModal)
