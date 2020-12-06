import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import Spinner from 'v1/shared/material/Spinner'
import $ from 'jquery'
import * as Materialize from 'materialize-css'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// @prop url [String] REQUIRED
// @prop clickable [Selector]
// @prop method [String]
// @prop paramName [String]
//
let DropzoneContainer
export default DropzoneContainer = createReactClass({
  x_getInitialState() {
    return {
      uploading: false,
      uploadPercent: 0,
      initialized: false,
    }
  },

  x_componentDidMount() {
    if (this.props.url != null) {
      const ___this = this

      return $(this.refs.dropzone).dropzone({
        clickable: this.props.clickable || undefined,
        url: this.props.url,
        method: this.props.method || 'POST',
        previewTemplate: '',
        headers: {
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content'),
        },
        paramName: this.props.paramName || 'image[image]',

        addedfile: file => {
          return this.setState({ uploading: true })
        },

        thumbnail(file, dataUrl) {},
        // Display the image in your file.previewElement

        uploadprogress: (file, progress, bytesSent) => {
          console.log(progress)
          return this.setState({ uploadPercent: progress })
        },

        success: () => {
          return this.setState({ uploading: false, uploadPercent: 0 })
        },

        error: () => {
          return this.setState({ uploading: false, uploadPercent: 0 })
        },

        init() {
          ___this.setState({ initialized: true })

          this.on('error', function (_, error) {
            if (error.errors != null ? error.errors.image : undefined) {
              return Materialize.toast({
                html: `Image ${error.errors.image}`,
                displayLength: 3000,
                classes: 'red',
              })
            } else {
              console.error(JSON.stringify(error))
              return Materialize.toast({
                html: `An unknown error has occurred :( Please find Mau and tell them this: ${JSON.stringify(
                  error
                )}`,
              })
            }
          })

          return this.on('success', function (_, data) {
            Materialize.toast({
              html: 'Image uploaded!',
              displayLength: 3000,
              classes: 'green',
            })
            if (___this.props.onUpload != null) {
              return ___this.props.onUpload(data)
            }
          })
        },
      })
    }
  },

  x_componentWillUnmount() {
    if (this.props.url != null && this.state.initialized) {
      // return Dropzone.forElement(this.refs.dropzone).destroy()
    }
  },

  render() {
    console.warn(
      'DropzoneContainer relies on jquery-dropzone which is no longer used in V2 JS pack. This component will do nothing now.'
    )
    return this.props.children

    let className, dropZoneContent
    if (this.state.uploading) {
      let statusMessage
      className = 'dropzone-container uploading'

      if (this.state.uploadPercent === 100) {
        statusMessage = 'Processing thumbnails...'
      } else {
        statusMessage = Math.round(this.state.uploadPercent) + '%'
      }

      dropZoneContent = (
        <div className="container">
          <h1 className="white-text">Uploading...</h1>
          <Spinner />
          <p className="flow-text">{statusMessage}</p>
        </div>
      )
    } else {
      className = 'dropzone-container'
      dropZoneContent = (
        <div className="container">
          <h1 className="white-text">Drop images to uplaod</h1>
          <div className="flow-text">Images only, please.</div>
        </div>
      )
    }

    return (
      <div className={className} ref="dropzone">
        <div className="dropzone-overlay valign-wrapper" data-dz-overlay>
          <div className="modal-page-content valign">{dropZoneContent}</div>
        </div>

        {this.props.children}
      </div>
    )
  },
})
