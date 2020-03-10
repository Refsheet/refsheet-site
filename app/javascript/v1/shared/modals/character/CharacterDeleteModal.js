import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Modal from 'v1/shared/Modal'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CharacterDeleteModal
export default CharacterDeleteModal = createReactClass({
  contextTypes: {
    router: PropTypes.object.isRequired,
  },

  propTypes: {
    character: PropTypes.object.isRequired,
  },

  _handleCharacterDelete(e) {
    $.ajax({
      url: this.props.character.path,
      type: 'DELETE',
      success: data => {
        M.Modal.getInstance(document.getElementById('delete-form')).close()
        Materialize.toast({
          html: `${data.name} deleted. :(`,
          displayLength: 3000,
        })
        return this.context.router.history.push('/' + data.user_id)
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
