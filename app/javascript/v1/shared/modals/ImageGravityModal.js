import React from 'react'
import createReactClass from 'create-react-class'

import Modal from 'v1/shared/Modal'
import Row from 'v1/shared/material/Row'
import Column from 'v1/shared/material/Column'

import $ from 'jquery'
import * as Materialize from 'materialize-css'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let ImageGravityModal
export default ImageGravityModal = createReactClass({
  getInitialState() {
    return {
      gravity: this.props.image.gravity || 'center',
      loading: false,
    }
  },

  handleGravityChange(e) {
    const gravity = $(e.target).closest('[data-gravity]').data('gravity')
    return this.setState({ gravity })
  },

  handleSave(e) {
    this.setState({ loading: true })
    $.ajax({
      url: this.props.image.path,
      type: 'PATCH',
      data: { image: { gravity: this.state.gravity } },
      success: data => {
        $(document).trigger('app:image:update', data)
        Materialize.toast({
          html:
            'Cropping settings saved. It may take a second to rebuild your thumbnails.',
          displayLength: 3000,
          classes: 'green',
        })
        this.setState({ loading: false })
        return Materialize.Modal.getInstance(
          document.getElementById('image-gravity-modal')
        ).close()
      },
      error: error => {
        Materialize.toast({
          html: 'Something bad happened',
          displayLength: 3000,
          classes: 'red',
        })
        this.setState({ loading: false })
        return console.log(error)
      },
    })
    return e.preventDefault()
  },

  handleClose(e) {
    $('#image-gravity-modal').modal('close')
    this.setState({ gravity: this.getInitialState() })
    return e.preventDefault()
  },

  render() {
    const gravity_crop = {
      center: { objectPosition: 'center' },
      north: { objectPosition: 'top' },
      south: { objectPosition: 'bottom' },
      east: { objectPosition: 'right' },
      west: { objectPosition: 'left' },
    }

    return (
      <Modal id="image-gravity-modal" title="Change Image Cropping">
        <p>
          Images can crop with a focus on the top, bottom, left, right or
          center. Ideally, the most important part of the image will be visible
          when cropped to a square or circle.
        </p>

        <div className="image-crop margin-top--large">
          <img
            src={this.props.image.url}
            style={gravity_crop[this.state.gravity]}
          />
          <a
            onClick={this.handleGravityChange}
            className="btn g-north"
            data-gravity="north"
          >
            <i className="material-icons">keyboard_arrow_up</i>
          </a>
          <a
            onClick={this.handleGravityChange}
            className="btn g-east"
            data-gravity="east"
          >
            <i className="material-icons">keyboard_arrow_right</i>
          </a>
          <a
            onClick={this.handleGravityChange}
            className="btn g-south"
            data-gravity="south"
          >
            <i className="material-icons">keyboard_arrow_down</i>
          </a>
          <a
            onClick={this.handleGravityChange}
            className="btn g-west"
            data-gravity="west"
          >
            <i className="material-icons">keyboard_arrow_left</i>
          </a>
          <a
            onClick={this.handleGravityChange}
            className="btn g-center"
            data-gravity="center"
          >
            <i className="material-icons">close</i>
          </a>
        </div>

        <Row className="actions">
          <Column>
            <div className="right">
              {this.state.loading ? (
                <a className="btn disabled">Saving...</a>
              ) : (
                <a
                  className="btn waves-effect waves-light"
                  onClick={this.handleSave}
                >
                  Save
                </a>
              )}
            </div>

            <a className="btn grey darken-3" onClick={this.handleClose}>
              <i className="material-icons">cancel</i>
            </a>
          </Column>
        </Row>
      </Modal>
    )
  },
})
