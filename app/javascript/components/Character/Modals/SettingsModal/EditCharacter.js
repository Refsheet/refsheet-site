import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Trans, withTranslation } from 'react-i18next'
import { TextInput, Row, Col, Checkbox } from 'react-materialize'
import { withCurrentUser, withMutations } from '../../../../utils/compose'
import updateSettings from './updateSettings.graphql'
import M from 'materialize-css'
import { withRouter } from 'react-router'
import { Authorized } from '../../../../policies'
import validate, { isRequired, isSluggable, isSlug } from 'utils/validate'
import { errorProps } from '../../../../utils/validate'

class EditCharacter extends Component {
  constructor(props) {
    super(props)

    this.validations = {
      name: [isRequired, isSluggable],
      slug: [isSlug],
      shortcode: [isSlug],
    }

    this.state = {
      character: this.props.character,
      submitting: false,
      errors: validate(this.props.character, this.validations),
    }
  }

  handleCancelClick(e) {
    e.preventDefault()
    this.props.onClose()
  }

  handleInputChange(e) {
    let character = { ...this.state.character }
    let value = e.target.value
    let name = e.target.name

    if (e.target.type === 'checkbox') {
      value = e.target.checked
      name = e.target.value
    }

    character[name] = value

    const errors = validate(character, this.validations)
    this.setState({ character, errors })
  }

  handleSubmit(e) {
    e.preventDefault()

    const { history, updateSettings, character, onSave = _c => {} } = this.props

    updateSettings({
      wrapped: true,
      variables: {
        ...this.state.character,
        id: character.id,
      },
    })
      .then(({ data: { updateCharacter } }) => {
        M.toast({
          html: 'Character saved!',
          classes: 'green',
          displayLength: 3000,
        })

        if (updateCharacter.slug !== character.slug) {
          const newPath = history.location.pathname.replace(
            '/' + character.slug,
            '/' + updateCharacter.slug
          )

          history.replace(newPath, {})
          return
        }

        onSave(updateCharacter)
      })
      .catch(({ formErrors }) => {
        this.setState({ errors: formErrors })
      })
  }

  render() {
    const { t } = this.props

    const { character, errors, submitting } = this.state

    const username =
      (character && character.user && character.user.username) || 'me'

    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        <Row>
          <TextInput
            s={12}
            m={6}
            label={t('labels.character_name', 'Name')}
            name={'name'}
            id={'character_name'}
            value={character.name}
            {...errorProps(errors.name)}
            onChange={this.handleInputChange.bind(this)}
          />
          <TextInput
            s={12}
            m={6}
            label={t('labels.character_species', 'Species / Race')}
            name={'species'}
            id={'character_species'}
            value={character.species}
            {...errorProps(errors.species)}
            onChange={this.handleInputChange.bind(this)}
          />
        </Row>

        <Row>
          <TextInput
            s={12}
            m={6}
            label={`refsheet.net/${username}/`}
            name={'slug'}
            id={'character_slug'}
            value={character.slug}
            {...errorProps(errors.slug)}
            onChange={this.handleInputChange.bind(this)}
          />
          <TextInput
            s={12}
            m={6}
            label={'ref.st/'}
            name={'shortcode'}
            id={'character_shortcode'}
            value={character.shortcode}
            {...errorProps(errors.shortcode)}
            onChange={this.handleInputChange.bind(this)}
          />
        </Row>

        <Row>
          <Col s={12} m={6}>
            <Checkbox
              label={t('labels.nsfw', 'NSFW')}
              value={'nsfw'}
              id={'character_nsfw'}
              checked={this.state.character.nsfw}
              onChange={this.handleInputChange.bind(this)}
            />
            <span className={'hint'}>
              <Trans
                i18nKey={'notice.character_nsfw_summary'}
                className={'hint muted'}
              >
                Flag your character as NSFW, which will apply to all images.
              </Trans>
            </span>
          </Col>
          <Col s={12} m={6}>
            <Checkbox
              label={t('labels.hidden', 'Hidden')}
              value={'hidden'}
              id={'character_hidden'}
              checked={this.state.character.hidden}
              onChange={this.handleInputChange.bind(this)}
            />
            <span className={'hint'}>
              <Trans
                i18nKey={'notice.character_hidden_summary'}
                className={'hint muted'}
              >
                Hide your character from other user's activity feeds and search
                / browse. Direct links will still work.
              </Trans>
            </span>
          </Col>
        </Row>

        <Row className={'no-margin margin-top--small'}>
          <Col s={12} m={6}>
            <Authorized
              object={this.props.character}
              user={this.props.currentUser}
              action={'destroy'}
            >
              <a
                className={'red-text block'}
                href={'#'}
                onClick={this.props.goTo('delete')}
              >
                {t('actions.delete_character', 'Delete Character...')}
              </a>
              <span className={'hint'}>
                <Trans
                  i18nKey={'notice.character_archive_summary'}
                  className={'hint muted'}
                >
                  Archives your character forever, including all images. This
                  cannot be undone.
                </Trans>
              </span>
            </Authorized>
          </Col>
          <Col s={12} m={6}>
            <Authorized
              object={this.props.character}
              user={this.props.currentUser}
              action={'transfer'}
            >
              <a
                className={'block'}
                href={'#'}
                onClick={this.props.goTo('transfer')}
              >
                {t('actions.transfer_character', 'Transfer Character...')}
              </a>
              <span className={'hint'}>
                <Trans
                  i18nKey={'notice.transfer_summary'}
                  className={'hint muted'}
                >
                  Transfer ownership of this profile to another user or
                  organization. They will have to accept.
                </Trans>
              </span>
            </Authorized>
          </Col>
        </Row>

        <Row className={'actions'}>
          <Col s={6}>
            <button
              type={'button'}
              onClick={this.handleCancelClick.bind(this)}
              className={'btn btn-secondary'}
            >
              {t('actions.cancel', 'Cancel')}
            </button>
          </Col>
          <Col s={6} className={'right-align'}>
            <button type={'submit'} className={'btn btn-primary'}>
              {t('actions.save', 'Save')}
            </button>
          </Col>
        </Row>
      </form>
    )
  }
}

EditCharacter.propTypes = {
  character: PropTypes.object.isRequired,
  onSave: PropTypes.func,
  goTo: PropTypes.func,
}

export default compose(
  withTranslation('common'),
  withMutations({ updateSettings }),
  withCurrentUser(),
  withRouter
)(EditCharacter)
