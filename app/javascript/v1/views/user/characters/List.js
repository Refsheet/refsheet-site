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
import StringUtils from '../../../../utils/StringUtils'
import CharacterLinkCard from 'v1/views/characters/CharacterLinkCard'

import $ from 'jquery'
import 'jquery-ui/ui/widgets/sortable'
import Model from '../../../utils/Model'

// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let List
export default List = createReactClass({
  propTypes: {
    characters: PropTypes.array.isRequired,
    onSort: PropTypes.func.isRequired,
    editable: PropTypes.bool,
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
    const $list = $(this.refs.list)

    return $list.sortable({
      items: 'li',
      placeholder: 'drop-target col s6 m4 xl3',
      tolerance: 'pointer',
      cursorAt: {
        top: 15,
        left: 15,
      },
      update: (e, el) => {
        const $item = $(el.item[0])

        if ($item.hasClass('dropped')) {
          $item.removeClass('dropped')
          return $list.sortable('cancel')
        } else {
          const position = $item.parent().children().index($item)
          return this._handleSwap($item.data('character-id'), position)
        }
      },
    })
  },

  _handleSwap(characterId, position) {
    const character = this.props.characters.filter(
      c => c.slug === characterId
    )[0]

    return Model.put(
      character.path,
      { character: { row_order_position: position } },
      data => {
        return this.props.onSort(data, position)
      }
    )
  },

  render() {
    if (this.props.characters.length) {
      let characterScope
      if (this.props.activeGroupId) {
        characterScope = this.props.characters.filter(c => {
          return c.group_ids.indexOf(this.props.activeGroupId) !== -1
        })
      } else {
        characterScope = this.props.characters
      }

      const characters = characterScope.map(character => (
        <li
          className="character-drag col s6 m4 xl3"
          key={character.slug}
          data-character-id={character.slug}
        >
          <CharacterLinkCard {...StringUtils.camelizeKeys(character)} />
        </li>
      ))

      return (
        <ul className="user-characters row" ref="list">
          {characters}
        </ul>
      )
    } else {
      return <p className="caption center">No characters to show here :(</p>
    }
  },
})
