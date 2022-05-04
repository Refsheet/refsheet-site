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
import compose, { withCurrentUser } from '../../utils/compose'
import { withRouter } from 'react-router'
import Error from '../../components/Shared/Error'
import Icon from 'react-materialize/lib/Icon'
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
    eagerLoad: PropTypes.object,
  },

  dataPath: '/users/:userId',

  paramMap: {
    userId: 'username',
  },

  getInitialState() {
    return {
      user: null,
      error: null,
      activeGroupId: window.location.hash.substring(1).toLowerCase(),
      characterName: null,
    }
  },

  setActiveGroupId(id, cb) {
    const activeGroupId = id || window.location.hash.substring(1).toLowerCase()

    if (activeGroupId === '') {
      this.setState({ activeGroupId: null }, cb)
      return
    }

    const slugs =
      this.state.user &&
      this.state.user.character_groups.map(g => g.slug.toLowerCase())

    if (slugs && slugs.indexOf(activeGroupId) !== -1) {
      this.setState({ activeGroupId }, cb)
    } else if (cb) {
      cb(this.state)
    }
  },

  componentDidMount() {
    StateUtils.load(this, 'user', undefined, this.setActiveGroupId)
  },

  UNSAFE_componentWillReceiveProps(newProps) {
    this.setActiveGroupId(undefined, () => {
      StateUtils.reload(this, 'user', newProps)
    })
  },

  goToCharacter(character) {
    const el = document.getElementById('character-form')
    if (el) {
      Materialize.Modal.getInstance(el).close()
    }
    return this.props.history.push(character.link)
  },

  handleUserChange(user) {
    this.setState({ user: { ...this.state.user, user } })

    if (user.username === this.props.currentUser.username) {
      return this.props.setCurrentUser(user)
    }
  },

  _handleUserFollow(followed, blocked) {
    const user = { ...this.state.user }
    user.followed = followed
    if (blocked !== undefined) user.blocked = blocked
    return this.setState({ user })
  },

  //== Schnazzy Fancy Root-level permutation operations!

  _handleGroupChange(group, character) {
    return StateUtils.updateItem(
      this,
      'user.character_groups',
      group,
      'slug',
      function () {
        if (character) {
          return HashUtils.findItem(
            this.state.user.characters,
            character,
            'slug',
            c => {
              const i = c.group_ids && c.group_ids.indexOf(group.slug)
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
      this.props.history.push(this.state.user.link)
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
    let actionButtons, editable, editPath, userChangeCallback, blocked

    if (this.state.error != null) {
      return <NotFound />
    }

    if (this.state.user == null) {
      return <main />
    }

    if (
      (this.props.currentUser != null
        ? this.props.currentUser.username
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

    blocked = this.state.user.blocked || this.state.user.blocks

    return (
      <Main title={[this.state.user.name, 'Users']}>
        {editable && (
          <Modal id="character-form" title="New Character">
            <p>
              It all starts with the basics. Give us a name and a species, and
              we'll set up a profile.
            </p>
            <NewCharacterForm
              onCancel={function (e) {
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
          user={this.state.user}
          blocked={this.state.user.blocked}
          blocks={this.state.user.blocks}
          followed={this.state.user.followed}
          onFollow={this._handleUserFollow}
          onUserChange={userChangeCallback}
        />

        <Section container className="margin-top--large padding-bottom--none">
          {!blocked && (
            <Characters
              groups={this.state.user.character_groups}
              characters={this.state.user.characters}
              editable={editable}
              userLink={this.state.user.link}
              activeGroupId={this.state.activeGroupId}
              onGroupChange={this._handleGroupChange}
              onGroupClick={this.setActiveGroupId}
              onGroupSort={this._handleGroupSort}
              onGroupDelete={this._handleGroupDelete}
              onCharacterDelete={this._handleGroupCharacterDelete}
              onCharacterSort={this._handleCharacterSort}
            />
          )}

          {blocked && (
            <div className={'caption center'}>
              <Icon large className={'grey-text text-darken-1'}>
                block
              </Icon>
              <div className={'margin-top--large'}>
                {this.state.user.blocks
                  ? 'This, apparently, is not the profile you are looking for.'
                  : 'You have blocked this user.'}
              </div>
            </div>
          )}
        </Section>
      </Main>
    )
  },
})

export default compose(withCurrentUser(true), withRouter)(User)
