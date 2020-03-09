/* eslint-disable
    no-undef,
    no-unused-vars,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let LegacyApp
export default LegacyApp = createReactClass({
  childContextTypes: {
    currentUser: PropTypes.object,
    session: PropTypes.object,
    setCurrentUser: PropTypes.func,
    eagerLoad: PropTypes.object,
    environment: PropTypes.string,
    reportImage: PropTypes.func,
  },

  getInitialState() {
    return {
      loading: 0,
      reportImageId: null,
      eagerLoad: this.props.eagerLoad || {},
    }
  },

  getChildContext() {
    return {
      currentUser: this.props.session.currentUser,
      session: StringUtils.unCamelizeKeys(this.props.session),
      setCurrentUser: this._onLogin,
      eagerLoad: this.state.eagerLoad,
      environment: this.props.environment,
      reportImage: this._reportImage,
    }
  },

  componentDidMount() {
    this.setState({ eagerLoad: null })
    console.debug('[App] Mount complete, clearing eager load.')

    return $(document)
      .on('app:session:update', (e, session) => {
        console.log('Event login (deprecated!): ', session)
        ReactGA.set({
          userId:
            session.current_user != null ? session.current_user.id : undefined,
        })
        return this.props.setCurrentUser(session.current_user)
      })
      .on('app:loading', () => {
        let val = this.state.loading + 1
        if (val <= 0) {
          val = 1
        }
        return this.setState({ loading: val })
      })
      .on('app:loading:done', () => {
        let val = this.state.loading - 1
        if (val < 0) {
          val = 0
        }
        return this.setState({ loading: val })
      })
  },

  _onLogin(user, callback) {
    this.props.setCurrentUser(user)
    return ReactGA.set({ userId: user != null ? user.id : undefined })
  },

  _reportImage(e) {
    let imageId
    if (e != null ? e.target : undefined) {
      imageId = $(e.target).data('image-id')
    } else {
      imageId = e
    }

    console.debug(`Reporting: ${imageId}`)
    return this.setState({ reportImageId: imageId })
  },

  render() {
    const currentUser = this.props.session.currentUser || {}

    return (
      <div id="rootApp">
        {this.state.loading > 0 && <LoadingOverlay />}

        {Packs.application.Chat && <Packs.application.Chat />}
        {Packs.application.NewLightbox && <Packs.application.NewLightbox />}
        {Packs.application.UploadModal && <Packs.application.UploadModal />}

        <SessionModal />
        <Views.Images.ReportModal imageId={this.state.reportImageId} />
        <Lightbox currentUser={currentUser} history={this.props.history} />

        <Packs.application.NavBar
          query={this.props.location.query.q}
          onUserChange={this._onLogin}
          notice={this.props.notice}
        />

        {this.props.children}

        <Footer />

        {/*<FeedbackModal name={ currentUser && currenUser.name } />*/}
        {/*<a className='btn modal-trigger feedback-btn' href='#feedback-modal'>Feedback</a>*/}

        {/*<NagBar action={{ href: 'https://patreon.com/refsheet', text: 'To Patreon!' }} type='neutral'>*/}
        {/*<div className='first-a-sincere-thank-you'>*/}
        {/*<strong>Hey, friend!</strong> &mdash; We've been making a lot of changes lately, and that's a good thing!*/}
        {/*</div>*/}

        {/*<div className='now-for-some-shameless-begging margin-top--small'>*/}
        {/*I can't make it happen without all your support. Thank you! In return, I'm giving all my supporters*/}
        {/*early access to new features as I develop them. Why not become a Patron?*/}
        {/*</div>*/}
        {/*</NagBar>*/}
      </div>
    )
  },
})

// HACK : Redux bridge for session
console.log('Bridging redux to session.')

const mapStateToProps = state => ({
  session: state.session,
})

const mapDispatchToProps = { setCurrentUser }

this.App = connect(mapStateToProps, mapDispatchToProps)(this.LegacyApp)
