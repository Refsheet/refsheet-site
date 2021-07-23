/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import Groups from './characters/Groups'
import List from './characters/List'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let Characters
export default Characters = createReactClass({
  propTypes: {
    groups: PropTypes.array.isRequired,
    characters: PropTypes.array.isRequired,
    editable: PropTypes.bool,
    userLink: PropTypes.string,
    activeGroupId: PropTypes.string,
    onGroupChange: PropTypes.func.isRequired,
    onGroupSort: PropTypes.func.isRequired,
    onGroupDelete: PropTypes.func.isRequired,
    onCharacterDelete: PropTypes.func.isRequired,
    onCharacterSort: PropTypes.func.isRequired,
  },

  render() {
    let listEditable
    const {
      groups,
      editable,
      userLink,
      activeGroupId,
      onGroupChange,
      onGroupSort,
      onGroupDelete,
      onCharacterDelete,
      onCharacterSort,
    } = this.props

    let { characters } = this.props

    if (!characters) {
      characters = []
    }

    if (activeGroupId) {
      listEditable = false
    } else {
      listEditable = editable
    }

    return (
      <div className="sidebar-container">
        <div className="sidebar">
          {editable && (
            <a
              href="#character-form"
              className="margin-bottom--large btn btn-block center waves-effect waves-light modal-trigger"
            >
              New Character
            </a>
          )}

          <Groups
            groups={groups}
            editable={editable}
            totalCount={characters.length}
            onChange={onGroupChange}
            onSort={onGroupSort}
            onGroupDelete={onGroupDelete}
            onCharacterDelete={onCharacterDelete}
            activeGroupId={activeGroupId}
            userLink={userLink}
          />
        </div>

        <div className="main-content">
          <List
            characters={characters}
            activeGroupId={activeGroupId}
            onSort={onCharacterSort}
            editable={listEditable}
          />
        </div>
      </div>
    )
  },
})
