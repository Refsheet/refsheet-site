import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Modal from 'v1/shared/Modal'
import * as Materialize from 'materialize-css'
import $ from 'jquery'
import compose from '../../../../utils/compose'
import { withRouter } from 'react-router'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const CharacterDeleteModal = createReactClass({
  propTypes: {
    character: PropTypes.object.isRequired,
  },

  _handleCharacterDelete(e) {
    $.ajax({
      url: this.props.character.path,
      type: 'DELETE',
      success: data => {
        let el = document.getElementById('delete-form')
        if (el) {
          const inst = Materialize.Modal.getInstance(el)
          if (inst) inst.close()
        }

        Materialize.toast({
          html: `${data.name} deleted. :(`,
          displayLength: 3000,
        })
        return this.props.history.push('/' + data.user_id)
      },

      error: error => {
        return Materialize.toast({
          html: 'Something went wrong.',
          displayLength: 3000,
          classes: 'red',
        })
      },
    })

    return e.preventDefault()
  },

  _handleDeleteClose(e) {
    $('#delete-form').modal('close')
    return e.preventDefault()
  },

  render() {
    return (
      <Modal id="delete-form">
        <h2>Delete Character</h2>
        <p>This action can not be undone! Are you sure?</p>

        <div className="actions margin-top--large">
          <a className="btn red right" onClick={this._handleCharacterDelete}>
            DELETE CHARACTER
          </a>
          <a className="btn" onClick={this._handleDeleteClose}>
            Cancel
          </a>
        </div>
      </Modal>
    )
  },
})

export default compose(withRouter)(CharacterDeleteModal)
