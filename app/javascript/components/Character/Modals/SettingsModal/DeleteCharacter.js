import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Trans, withTranslation } from 'react-i18next'
import { Row, Col, TextInput } from 'react-materialize'
import archiveCharacter from './archiveCharacter.graphql'
import { withMutations } from '../../../../utils/compose'
import { withRouter } from 'react-router'
import M from 'materialize-css'
import LinkUtils from 'utils/LinkUtils'

class DeleteCharacter extends Component {
  constructor(props) {
    super(props)

    this.state = { confirmation: '', errors: {} }
  }

  handleConfirmationChange(e) {
    e.preventDefault()
    const confirmation = e.target.value
    this.setState({ confirmation })
  }

  handleSubmit(e) {
    e.preventDefault()

    const {
      archiveCharacter,
      character: { id, username },
      t,
      history,
    } = this.props
    const { confirmation } = this.state

    archiveCharacter({
      wrapped: true,
      variables: {
        id,
        confirmation,
      },
    })
      .then(({ data: { archiveCharacter } }) => {
        M.toast({
          html: t('notice.character_deleted', 'Character deleted.'),
          displayLength: 3000,
          classes: 'orange',
        })

        // TODO: The V2 router cannot push routes that would be handled by the V1 router. :thinking:
        history.push(LinkUtils.userPath({ username }), {})
      })
      .catch(({ validationErrors }) => {
        this.setState({ errors: validationErrors })
      })
  }

  render() {
    const { t, character } = this.props

    return (
      <form
        onSubmit={this.handleSubmit.bind(this)}
        className={'no-input-margins'}
      >
        <Trans i18nKey={'notice.character_delete'}>
          <p>
            This will delete your character, and all images and profile data.
            Any forum posts or social activity will become unattributed. This
            action cannot be undone.
          </p>
          <p>
            If you really want to continue, please type your character URL
            below.
          </p>
        </Trans>

        <code>{character.slug}</code>

        <Row className={'margin-top--medium'}>
          <TextInput
            s={12}
            name={'confirmation'}
            id={'character_delete_confirmation'}
            label={t('labels.character_delete_confirmation', 'Confirmation')}
            value={this.state.confirmation}
            onChange={this.handleConfirmationChange.bind(this)}
          />
        </Row>

        <Row className={'actions'}>
          <Col s={6}>
            <button
              type={'button'}
              className={'btn btn-secondary'}
              onClick={this.props.goTo('settings')}
            >
              {t('actions.cancel', 'Cancel')}
            </button>
          </Col>
          <Col s={6} className={'right-align'}>
            <button
              type={'submit'}
              className={'btn btn-primary red darken-1 white-text'}
              disabled={this.state.confirmation !== character.slug}
            >
              {t('actions.delete_character_confirmed', 'Delete Character')}
            </button>
          </Col>
        </Row>
      </form>
    )
  }
}

DeleteCharacter.propTypes = {
  character: PropTypes.object.isRequired,
  onSave: PropTypes.func,
  goTo: PropTypes.func.isRequired,
}

export default compose(
  withTranslation('common'),
  withMutations({ archiveCharacter }),
  withRouter
)(DeleteCharacter)
