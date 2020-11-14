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

class Layout extends Component {
  constructor(props) {
    super(props)

    this.state = {}

    this.handleKeyDown = this.handleKeyDown.bind(this)
  }

  // TODO: Refactor this to a keystroke provider or somethn
  componentDidMount() {
    document.addEventListener('keydown', this.handleKeyDown)
  }

  componentWillUnmount() {
    document.removeEventListener('keydown', this.handleKeyDown)
  }

  handleKeyDown(e) {
    return

    // TODO: Input filtering isn't filtering.

    const { openNewCharacterModal } = this.props

    const key = e.key.toLowerCase()

    if (
      ['INPUT', 'TEXTAREA'].indexOf(e.target.nodeName) ||
      e.target.contentEditable !== 'inherit'
    ) {
      return
    }

    if (key === '/') {
      openNewCharacterModal()
    }
  }

  render() {
    const { t, location, notice } = this.props

    return (
      <div id={'rootApp'}>
        <Lightbox />
        <UploadModal />
        <SessionModal />
        <SupportModal />
        <NewCharacterModal />

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
}

const mapDispatchToProps = {
  openNewCharacterModal,
}

export default compose(
  withErrorBoundary,
  withRouter,
  connect(undefined, mapDispatchToProps)
)(Layout)
