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
import { ThemeProvider } from 'styled-components'
import themes from '../../themes'

class Layout extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render() {
    const { location, notice, theme: themeSettings } = this.props
    const { name: themeName } = themeSettings || {}
    const theme = themes[themeName] || themes.dark

    return (
      <ThemeProvider theme={theme.base}>
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
      </ThemeProvider>
    )
  }
}

Layout.propTypes = {
  notice: PropTypes.string,
  updateAvailable: PropTypes.bool,
}

const mapStateToProps = ({ theme }) => ({
  theme,
})

const mapDispatchToProps = {
  openNewCharacterModal,
}

export default compose(
  withErrorBoundary,
  withRouter,
  withTranslation('common'),
  connect(mapStateToProps, mapDispatchToProps)
)(Layout)
