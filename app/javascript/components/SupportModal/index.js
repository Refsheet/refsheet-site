import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'
import compose, { withCurrentUser } from 'utils/compose'
import { withNamespaces } from 'react-i18next'
import Modal from '../Styled/Modal'

class SupportModal extends Component {
  render() {
    const { isOpen, currentUser, t } = this.props
    console.log(this.props)

    if (!isOpen) {
      return null
    }

    return (
      <Modal
        autoOpen
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

const mapDispatchToProps = {}

export default compose(
  connect(mapStateToProps, mapDispatchToProps),
  withNamespaces('common'),
  withCurrentUser()
)(SupportModal)
