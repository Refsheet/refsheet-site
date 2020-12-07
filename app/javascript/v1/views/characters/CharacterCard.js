/* do-not-disable-eslint
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
import React from 'react'
import createReactClass from 'create-react-class'
import PropTypes from 'prop-types'
import * as Materialize from 'materialize-css'
import Attribute from '../../shared/attributes/attribute'
import RichText from '../../../components/Shared/RichText'
import Follow from 'v1/views/user/Follow'
import Attributes from './_attributes'
import AttributeTable from 'v1/shared/attributes/attribute_table'
import $ from 'jquery'
import HashUtils from '../../utils/HashUtils'
import Flash from '../../../utils/Flash'
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
let CharacterCard
export default CharacterCard = createReactClass({
  getInitialState() {
    return { character: this.props.character }
  },

  UNSAFE_componentWillUpdate(newProps) {
    if (newProps.character !== this.props.character) {
      return this.setState({ character: newProps.character })
    }
  },

  handleAttributeChange(data, onSuccess = () => {}, onError = () => {}) {
    const postData = { character: {} }
    postData.character[data.id] = data.value

    return $.ajax({
      url: this.state.character.path,
      type: 'PATCH',
      data: postData,
      success: data => {
        this.setState({ character: data })
        return onSuccess()
      },
      error: error => {
        if (error.status === 401 || error.status === 500) {
          Flash.error(error.statusText)
        }
        return onError({
          value:
            error.JSONData != null
              ? error.JSONData.errors[data.id]
              : error.statusText,
        })
      },
    })
  },

  handleSpecialNotesChange(data) {
    return new Promise((resolve, reject) => {
      $.ajax({
        url: this.state.character.path,
        type: 'PATCH',
        data: { character: data },
        success: data => {
          this.setState({ character: data })
          resolve(data)
        },

        error: error => {
          reject(
            error.JSONData != null
              ? error.JSONData.errors['special_notes']
              : undefined
          )
        },
      })
    })
  },

  handleProfileImageEdit() {
    return $(document).trigger('app:character:profileImage:edit')
  },

  _handleFollow(f) {
    return this.setState(
      HashUtils.set(this.state, 'character.followed', f),
      () =>
        Materialize.toast({
          html: `Character ${f ? 'followed!' : 'unfollowed.'}`,
          displayLength: 3000,
          classes: 'green',
        })
    )
  },

  _handleChange(char) {
    if (this.props.onChange) {
      this.props.onChange(char)
    }
    return this.setState({ character: char })
  },

  render() {
    let attributeUpdate, editable, nickname, notesUpdate

    if (this.props.edit) {
      attributeUpdate = this.handleAttributeChange
      notesUpdate = this.handleSpecialNotesChange
      editable = true
    }

    const description = (
      <div className="description">
        <AttributeTable
          onAttributeUpdate={attributeUpdate}
          defaultValue="Unspecified"
          freezeName
          hideEmpty={!this.props.edit}
          hideNotesForm
        >
          <Attribute
            id="species"
            name="Species"
            value={this.state.character.species}
          />
        </AttributeTable>

        <Attributes
          characterPath={this.state.character.path}
          attributes={this.state.character.custom_attributes}
          onChange={this._handleChange}
          editable={editable}
        />

        {(this.state.character.special_notes || editable) && (
          <div className="important-notes margin-top--large margin-bottom--medium">
            <RichText
              title={'Important Notes'}
              slim
              name={'special_notes'}
              contentHtml={this.state.character.special_notes_html || ''}
              content={this.state.character.special_notes}
              onChange={notesUpdate}
            />
          </div>
        )}
      </div>
    )

    if (this.props.nickname) {
      nickname = (
        <span className="nickname"> ({this.state.character.nickname})</span>
      )
    }

    let prefixClass = 'title-prefix'
    const suffixClass = 'title-suffix'

    if (this.props.officialPrefix) {
      prefixClass += ' official'
    }

    if (this.props.officialSuffix) {
      prefixClass += ' official'
    }

    const gravity_crop = {
      center: { objectPosition: 'center' },
      north: { objectPosition: 'top' },
      south: { objectPosition: 'bottom' },
      east: { objectPosition: 'right' },
      west: { objectPosition: 'left' },
    }

    return (
      <div className="character-card" style={{ minHeight: 400 }}>
        <div className="character-details">
          <div className="heading">
            <div className="right">
              <Follow
                followed={this.state.character.followed}
                username={this.state.character.user_id}
                onFollow={this._handleFollow}
                short
              />
            </div>

            <h1 className="name">
              <span className={prefixClass}>{this.props.titlePrefix} </span>
              <span className="real-name">{this.state.character.name}</span>
              {nickname}
              <span className={suffixClass}> {this.props.titleSuffix}</span>
            </h1>
          </div>

          {description}
        </div>

        {/*<div className='user-icon'>
            <Link to={ '/' + this.state.character.user_id } className='tooltipped' data-tooltip={ this.state.character.user_name } data-position='bottom'>
                <img className='circle' src={ this.state.character.user_avatar_url } />
            </Link>
        </div>*/}

        <div className="character-image" onClick={this.handleImageClick}>
          <div className="slant" />
          <img
            src={this.state.character.profile_image.medium}
            data-image-id={this.state.character.profile_image.id}
            style={gravity_crop[this.state.character.profile_image.gravity]}
          />

          {editable && (
            <a
              className="image-edit-overlay"
              onClick={this.handleProfileImageEdit}
            >
              <div className="content">
                <i className="material-icons">photo_camera</i>
                Change Image
              </div>
            </a>
          )}
        </div>
      </div>
    )
  },
})
