import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import compose, { withCurrentUser } from 'utils/compose'
import { withNamespaces } from 'react-i18next'
import Modal from '../Styled/Modal'
import { closeSupportModal } from '../../actions'

class SupportModal extends Component {
  handleClose() {
    this.props.closeSupportModal()
  }

  render() {
    const { isOpen, currentUser, t } = this.props

    if (!isOpen) {
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
  isOpen: PropTypes.bool,
  currentUser: {
    username: PropTypes.string,
  },
}

const mapStateToProps = ({ supportModal }, props) => ({
  ...props,
  ...supportModal,
})

const mapDispatchToProps = {
  closeSupportModal
}

export default compose(
  connect(mapStateToProps, mapDispatchToProps),
  withNamespaces('common'),
  withCurrentUser()
)(SupportModal)
