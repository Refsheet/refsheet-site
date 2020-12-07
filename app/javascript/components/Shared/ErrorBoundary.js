import React, { Component } from 'react'
import * as Sentry from '@sentry/browser'

export default class ErrorBoundary extends Component {
  constructor(props) {
    super(props)

    this.state = {
      error: null,
      errorInfo: null,
      eventId: null,
    }
  }

  componentDidCatch(error, errorInfo) {
    let eventId = null

    if (console && console.error) {
      console.error(error, errorInfo)
    }

    if (Sentry) {
      eventId = Sentry.captureException(error)
    }

    this.setState({
      error,
      errorInfo,
      eventId,
    })
  }

  renderError() {
    const { eventId } = this.state
    const errorString = (
      <div>
        <h1>You've encountered a bug.</h1>
        <p className={'larger'}>
          You've encountered a bug, and Refsheet.net has crashed. Usually,
          reloading the page will fix this.
        </p>
      </div>
    )

    const styles = {
      shadow: {
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        zIndex: 995,
        backgroundColor: 'rgba(0,0,0,0.8)',
      },
      container: {
        position: 'fixed',
        top: '50%',
        transform: 'translate(-50%, -50%)',
        left: '50%',
        padding: '1.5rem',
        maxWidth: '600px',
        width: '80vw',
        zIndex: 100000,
        backgroundColor: '#212121 !important',
        color: '#c9c9c9 !important',
      },
    }

    if (eventId) {
      const report = e => {
        e.preventDefault()
        Sentry.showReportDialog({
          eventId,
        })
      }

      return (
        <div style={styles.shadow}>
          <div
            className={'render-error card-panel z-depth-3'}
            style={styles.container}
          >
            {errorString}
            <p>
              This issue has just been reported to the developer, but it is
              possible I'll need more information to debug it. If you are about
              to report this in the Forums or Twitter, please send along this
              error ID: <code>{eventId}</code>.
            </p>
            <p>
              You can also provide additional information by clicking this
              button, which will pop up a box asking for some details:
            </p>
            <p>
              <a onClick={report} href={'#bugreport'} className={'btn'}>
                Report Bug
              </a>
            </p>
          </div>
        </div>
      )
    } else {
      return (
        <div style={styles.shadow}>
          <div
            style={styles.container}
            className={'render-error card-panel z-depth-3'}
          >
            {errorString}
          </div>
        </div>
      )
    }
  }

  render() {
    if (this.state.errorInfo) {
      return this.renderError()
    }

    return this.props.children
  }
}

export const withErrorBoundary = WrappedComponent => props => (
  <ErrorBoundary>
    <WrappedComponent {...props} />
  </ErrorBoundary>
)
