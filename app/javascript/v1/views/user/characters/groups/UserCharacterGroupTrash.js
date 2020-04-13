/* do-not-disable-eslint
    no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'

import $ from 'jquery'
import 'jquery-ui/ui/widgets/droppable'
import Model from '../../../../utils/Model'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let UserCharacterGroupTrash
export default UserCharacterGroupTrash = createReactClass({
  propTypes: {
    onGroupDelete: PropTypes.func.isRequired,
    onCharacterDelete: PropTypes.func.isRequired,
    activeGroupId: PropTypes.string,
    characterDragActive: PropTypes.bool,
  },

  getInitialState() {
    return { dropOver: false }
  },

  componentDidMount() {
    const $trash = $(this.refs.trash)

    return $trash.droppable({
      tolerance: 'pointer',
      accept: '.character-drag, .sortable-link',
      over: (_, ui) => {
        const $source = $(ui.draggable)
        if ($source.hasClass('character-drag')) {
          $source.siblings('.drop-target').hide()
        }
        return this.setState({ dropOver: true })
      },

      out: (_, ui) => {
        const $source = $(ui.draggable)
        if ($source.hasClass('character-drag')) {
          $source.siblings('.drop-target').show()
        }
        return this.setState({ dropOver: false })
      },

      drop: (event, ui) => {
        let sourceId
        console.log('===DROP')
        const $source = ui.draggable
        $source.addClass('dropped')

        if ($source.data('character-id')) {
          sourceId = $source.data('character-id')
          this._handleCharacterDrop(sourceId, () => $source.remove)
        } else {
          sourceId = $source.data('group-id')
          this._handleGroupDrop(sourceId, () => $source.remove)
        }

        return this.setState({ dropOver: false })
      },
    })
  },

  _handleGroupDrop(groupId, callback) {
    return Model.delete(`/character_groups/${groupId}`, () => {
      this.props.onGroupDelete(groupId)
      return callback()
    })
  },

  _handleCharacterDrop(characterId, callback) {
    return Model.delete(
      `/character_groups/${this.props.activeGroupId}/characters/${characterId}`,
      () => {
        this.props.onCharacterDelete(characterId)
        return callback()
      }
    )
  },

  render() {
    let icon, message
    if (this.state.dropOver) {
      icon = 'delete_forever'
    } else {
      icon = 'delete'
    }

    if (this.props.characterDragActive) {
      message = 'Remove From Group'
    } else {
      message = 'Delete Group'
    }

    return (
      <li className="trash fixed" ref="trash">
        <i className="material-icons left folder">{icon}</i>
        <span className="name">{message}</span>
      </li>
    )
  },
})
