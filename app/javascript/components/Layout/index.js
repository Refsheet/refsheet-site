import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withTranslation } from 'react-i18next'
import compose from 'utils/compose'
import Footer from './Footer'
import NavBar from '../NavBar'
import Chat from '../Chat/ConversationTray'
import Lightbox from '../Lightbox'
import UploadModal from '../Image/UploadModal'
import Routes from '../App/Routes'
import { withRouter } from 'react-router'
import SessionModal from '../../v1/shared/modals/SessionModal'
import { withErrorBoundary } from '../Shared/ErrorBoundary'
import SupportModal from '../SupportModal'
import { connect } from 'react-redux'
import { openNewCharacterModal, openSupportModal } from '../../actions'
import NewCharacterModal from '../User/Modals/NewCharacterModal'
import ReportModal from '../../v1/views/images/report_modal'

class Layout extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render() {
    const { location, notice } = this.props

    return (
      <div id={'rootApp'}>
        <Lightbox />
        <UploadModal />
        <SessionModal />
        <SupportModal />
        <NewCharacterModal />
        <ReportModal />

        <NavBar
          query={location.query.q}
          onUserChange={this._onLogin}
          notice={notice}
        />

        <Routes />
        <Footer />

        <Chat />
      </div>
    )
  }
}

Layout.propTypes = {
  notice: PropTypes.string,
  updateAvailable: PropTypes.bool,
}

const mapDispatchToProps = {
  openNewCharacterModal,
}

export default compose(
  withErrorBoundary,
  withRouter,
  withTranslation('common'),
  connect(undefined, mapDispatchToProps)
)(Layout)
