/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import UserCharacterGroupForm from './UserCharacterGroupForm'
import { Link } from 'react-router-dom'

import $ from 'jquery'
import 'jquery-ui/ui/widgets/droppable'
import Model from '../../../../utils/Model'
import NumberUtils from '../../../../utils/NumberUtils'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let UserCharacterGroupLink
export default UserCharacterGroupLink = createReactClass({
  propTypes() {
    return {
      group: PropTypes.object.isRequired,
      editable: PropTypes.bool,
      onChange: PropTypes.func,
      active: PropTypes.bool,
    }
  },

  getInitialState() {
    return {
      edit: false,
      dropOver: false,
    }
  },

  componentDidMount() {
    return this._initialize()
  },

  componentDidUpdate() {
    return this._initialize()
  },

  _initialize() {
    if (!this.props.editable) {
      return
    }

    const $link = $(this.refs.link)

    return $link.droppable({
      tolerance: 'pointer',
      accept: '.character-drag',
      over: (_, ui) => {
        $(ui.draggable).siblings('.drop-target').hide()
        return this.setState({ dropOver: true })
      },

      out: (_, ui) => {
        $(ui.draggable).siblings('.drop-target').show()
        return this.setState({ dropOver: false })
      },

      drop: (event, ui) => {
        const $source = ui.draggable
        $source.addClass('dropped')
        const sourceId = $source.data('character-id')
        this._handleDrop(sourceId)
        return this.setState({ dropOver: false })
      },
    })
  },

  _handleEdit(e) {
    this.setState({ edit: true })
    return e.preventDefault()
  },

  _handleChange(data) {
    this.setState({ edit: false })
    return this.props.onChange(data)
  },

  _handleDrop(characterId) {
    return Model.post(
      this.props.group.path + '/characters',
      { id: characterId },
      data => {
        return this.props.onChange(data, characterId)
      }
    )
  },

  render() {
    const { editable, active } = this.props

    if (this.state.edit) {
      return (
        <UserCharacterGroupForm
          group={this.props.group}
          onChange={this._handleChange}
        />
      )
    } else {
      let count, folder
      const classNames = ['sortable-link', 'character-group-drop']
      if (active) {
        classNames.push('active')
      }

      if (editable) {
        count = this.props.group.characters_count
      } else {
        count = this.props.group.visible_characters_count
      }

      if (this.state.dropOver) {
        folder = 'add'
      } else if (active) {
        folder = 'folder_open'
      } else {
        folder = 'folder'
      }

      return (
        <li
          className={classNames.join(' ')}
          ref="link"
          data-group-id={this.props.group.slug}
        >
          <i className="material-icons left folder">{folder}</i>

          <Link to={this.props.group.link} className="name">
            {this.props.group.name}
          </Link>

          <span className="count">{NumberUtils.format(count)}</span>

          {editable && (
            <a href="#" onClick={this._handleEdit} className="action">
              <i className="material-icons">edit</i>
            </a>
          )}
        </li>
      )
    }
  },
})
