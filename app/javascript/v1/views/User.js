/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import PropTypes from 'prop-types'
import createReactClass from 'create-react-class'

import Header from './user/Header'
import NotFound from './static/NotFound'
import FixedActionButton from '../shared/FixedActionButton'
import ActionButton from '../shared/ActionButton'
import Main from '../shared/Main'
import DropzoneContainer from '../shared/DropzoneContainer'
import Modal from '../shared/Modal'
import NewCharacterForm from './characters/NewCharacterForm'
import UserSettingsModal from '../shared/modals/UserSettingsModal'

import $ from 'jquery'
import * as Materialize from 'materialize-css'
import StateUtils from '../utils/StateUtils'
import HashUtils from '../utils/HashUtils'
import Characters from './user/Characters'
import Section from '../../components/Shared/Section'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */

const User = createReactClass({
  contextTypes: {
    router: PropTypes.object.isRequired,
    currentUser: PropTypes.object,
    eagerLoad: PropTypes.object,
    setCurrentUser: PropTypes.func.isRequired,
  },

  dataPath: '/users/:userId',

  paramMap: {
    userId: 'username',
  },

  getInitialState() {
    return {
      user: null,
      error: null,
      activeGroupId: null,
      characterName: null,
    }
  },

  componentDidMount() {
    return this.setState(
      { activeGroupId: window.location.hash.substring(1) },
      function() {
        return StateUtils.load(this, 'user')
      }
    )
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    if (
      (newProps.match != null ? newProps.match.params.userId : undefined) !==
      (this.state.user != null ? this.state.user.username : undefined)
    ) {
      StateUtils.reload(this, 'user', newProps)
      return
    }

    return this.setState(
      { activeGroupId: window.location.hash.substring(1) },
      function() {
        return StateUtils.reload(this, 'user', newProps)
      }
    )
  },

  goToCharacter(character) {
    Materialize.Modal.getInstance(
      document.getElementById('character-form')
    ).close()
    return this.context.router.history.push(character.link)
  },

  handleUserChange(user) {
    this.setState({ user })

    if (user.username === this.context.currentUser.username) {
      return this.context.setCurrentUser(user)
    }
  },

  _handleUserFollow(followed) {
    const user = $.extend({}, this.state.user)
    user.followed = followed
    return this.setState({ user })
  },

  //== Schnazzy Fancy Root-level permutation operations!

  _handleGroupChange(group, character) {
    return StateUtils.updateItem(
      this,
      'user.character_groups',
      group,
      'slug',
      function() {
        if (character) {
          return HashUtils.findItem(
            this.state.user.characters,
            character,
            'slug',
            c => {
              const i = c.group_ids.indexOf(group.slug)
              if (i >= 0) {
                c.group_ids.splice(i, 1)
              } else {
                c.group_ids.push(group.slug)
              }
              return StateUtils.updateItem(this, 'user.characters', c, 'slug')
            }
          )
        }
      }
    )
  },

  _handleGroupDelete(groupId) {
    if (groupId === this.state.activeGroupId) {
      this.context.router.history.push(this.state.user.link)
    }
    return StateUtils.removeItem(this, 'user.character_groups', groupId, 'slug')
  },

  _handleGroupSort(group, position) {
    return StateUtils.sortItem(
      this,
      'user.character_groups',
      group,
      position,
      'slug'
    )
  },

  _handleCharacterSort(character, position) {
    return StateUtils.sortItem(
      this,
      'user.characters',
      character,
      position,
      'slug'
    )
  },

  _handleGroupCharacterDelete(group) {
    return this._handleGroupChange(group)
  },

  //== Render

  render() {
    let actionButtons, editable, editPath, userChangeCallback
    if (this.state.error != null) {
      return <NotFound />
    }

    if (this.state.user == null) {
      return <main />
    }

    if (
      (this.context.currentUser != null
        ? this.context.currentUser.username
        : undefined) === this.state.user.username
    ) {
      actionButtons = (
        <FixedActionButton
          clickToToggle={true}
          className="red"
          tooltip="Menu"
          icon="menu"
          id="user-actions"
        >
          <ActionButton
            className="green lighten-1 modal-trigger"
            tooltip="New Refsheet"
            href="#character-form"
            icon="note_add"
            id="action-new-character"
          />
          <ActionButton
            className="blue darken-1 modal-trigger"
            tooltip="User Settings"
            href="#user-settings-modal"
            icon="settings"
            id="action-settings"
          />
        </FixedActionButton>
      )

      userChangeCallback = this.handleUserChange
      editable = true
      editPath = this.state.user.path
    }

    return (
      <Main title={[this.state.user.name, 'Users']}>
        {editable && (
          <Modal id="character-form" title="New Character">
            <p>
              It all starts with the basics. Give us a name and a species, and
              we'll set up a profile.
            </p>
            <NewCharacterForm
              onCancel={function(e) {
                $('#character-form').modal('close')
                e.preventDefault()
              }}
              onCreate={this.goToCharacter}
              className="margin-top--large"
              newCharacterPath={this.state.user.path + '/characters'}
            />
          </Modal>
        )}

        {actionButtons}

        {editable && (
          <UserSettingsModal
            user={this.state.user}
            onChange={this.handleUserChange}
          />
        )}

        <Header
          {...this.state.user}
          onFollow={this._handleUserFollow}
          onUserChange={userChangeCallback}
        />

        <Section container className="margin-top--large padding-bottom--none">
          <Characters
            groups={this.state.user.character_groups}
            characters={this.state.user.characters}
            editable={editable}
            userLink={this.state.user.link}
            activeGroupId={this.state.activeGroupId}
            onGroupChange={this._handleGroupChange}
            onGroupSort={this._handleGroupSort}
            onGroupDelete={this._handleGroupDelete}
            onCharacterDelete={this._handleGroupCharacterDelete}
            onCharacterSort={this._handleCharacterSort}
          />
        </Section>
      </Main>
    )
  },
})

export default User
