import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withNamespaces } from 'react-i18next'
import compose from 'utils/compose'
import Footer from '../Layout/Footer'
import NavBar from '../NavBar'
import Chat from '../Chat/ConversationTray'
import Lightbox from '../Lightbox'
import UploadModal from '../Image/UploadModal'
import { SessionModal } from '../Shared/V1'
import Routes from './Routes'
import { withRouter } from 'react-router'

class Layout extends Component {
  constructor(props) {
    super(props)

    this.state = {}
  }

  render() {
    const { t, location, notice } = this.props

    return (
      <div id={'#rootApp'}>
        <Lightbox />
        <UploadModal />
        <SessionModal />

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

export default compose(
  // withNamespaces('common'),
  withRouter
  // TODO: Add HOC bindings here
)(Layout)
