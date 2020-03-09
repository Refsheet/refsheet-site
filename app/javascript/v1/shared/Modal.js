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
export default Modal = createReactClass({
  componentDidMount() {
    const $modal = M.Modal.init(this.refs.modal, {
      onCloseEnd: args => {
        if (this.props.sideSheet) {
          document.body.classList.remove(
            'side-sheet-open',
            'side-sheet-closing',
            'side-sheet-opening'
          )
        }

        if (this.props.onClose) {
          this.props.onClose(args)
        }

        if (window.location.hash === `#${this.props.id}`) {
          return window.history.replaceState({}, '', window.location.pathname)
        }
      },

      onCloseStart: () => {
        if (this.props.sideSheet) {
          return document.body.classList.add('side-sheet-closing')
        }
      },

      onOpenStart: () => {
        if (this.props.id) {
          window.history.replaceState(
            {},
            '',
            window.location.pathname + `#${this.props.id}`
          )
        }

        if (this.props.sideSheet) {
          document.body.classList.add('side-sheet-opening')
          return document.body.classList.add('side-sheet-open')
        }
      },

      onOpenEnd: () => {
        $(document).trigger('materialize:modal:ready')
        // Fix incorrect tab indicator after modal open:
        const tabs = this.refs.modal.querySelectorAll('.tabs')
        return tabs.forEach(function(tab) {
          const inst = M.Tabs.getInstance(tab)
          return inst != null ? inst.updateTabIndicator() : undefined
        })
      },
    })

    if (window.location.hash === `#${this.props.id}`) {
      $modal.open()
    }

    if (this.props.autoOpen) {
      return $modal.open()
    }
  },

  componentWillUnmount() {
    const $modal = M.Modal.getInstance(this.refs.modal)
    $modal.close()
    return $modal.destroy()
  },

  close() {
    const $modal = M.Modal.getInstance(this.refs.modal)
    return $modal.close()
  },

  _handleClose(e) {
    this.close()
    return e.preventDefault()
  },

  render() {
    const classes = ['modal']
    if (this.props.wide) {
      classes.push('wide')
    }
    if (this.props.bottomSheet) {
      classes.push('bottom-sheet')
    }
    if (this.props.sideSheet) {
      classes.push('side-sheet')
    }
    if (this.props.className) {
      classes.push(this.props.className)
    }

    const containerClasses = ['modal-stretch']
    if (!this.props.noContainer) {
      containerClasses.push('modal-content')
    }
    if (this.props.container) {
      containerClasses.push('container')
    }

    const actions = (this.props.actions || []).map(action => (
      <a
        className={
          'modal-action waves-effect waves-light btn ' + action.className
        }
        key={action.name}
        onClick={action.action}
      >
        {action.name}
      </a>
    ))

    return (
      <div ref="modal" className={classes.join(' ')} id={this.props.id}>
        <div className="modal-body">
          {this.props.title && (
            <div className="modal-header-wrap">
              <div className="modal-header">
                <a className="modal-close" onClick={this._handleClose}>
                  <i className="material-icons">close</i>
                </a>

                <h2>{this.props.title}</h2>
              </div>
            </div>
          )}

          <div className={containerClasses.join(' ')}>
            {this.props.children}
          </div>

          {actions.length > 0 && <div className="modal-footer">{actions}</div>}
        </div>
      </div>
    )
  },
})
