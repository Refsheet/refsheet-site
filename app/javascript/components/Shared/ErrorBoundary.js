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
    const { eventId, error } = this.state
    const errorString = (
      <div>
        <h1>You've encountered a bug.</h1>
        <p className={'larger'}>
          You've encountered a bug, and Refsheet.net has crashed. We're very
          sorry, but this happens from time to time. Every new fix is a new bug,
          too.
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
            <p className={'caption larger strong'}>
              PROVIDE THE ERROR CODES BELOW IF YOU ARE GOING TO REPORT THIS BUG
              TO THE SITE ADMINISTRATORS. Thank you for helping us help you.
            </p>
            <p>
              Anonymous details of this bug have been logged, but we have no way
              to know which bug you are referring to unless you give us one of
              the codes below, which will identify it in our system and give us
              the details we need to fix it.
            </p>
            <p className={'caption center'}>
              <code>{eventId}</code>
            </p>
            <p>
              This copypasta can also help us find it if the event ID above
              doesn't match anything. Sometimes that happens, especially if you
              are using various ad blockers that prevent our bug-tracking code
              from working.
            </p>
            <textarea readOnly>{btoa(error)}</textarea>
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
