import React, { Component } from 'react'
import PropTypes from 'prop-types'
import compose from 'utils/compose'
import { Trans, withNamespaces } from 'react-i18next'
import { Row, Col, TextInput } from 'react-materialize'

class TransferCharacter extends Component {
  constructor(props) {
    super(props)

    this.state = { destination: '' }
  }

  handleDestinationChange(e) {
    e.preventDefault()
    const destination = e.target.value
    this.setState({ destination })
  }

  handleSubmit(e) {
    e.preventDefault()
    console.log(this.state.destination)
  }

  render() {
    const { t } = this.props

    return (
      <form
        onSubmit={this.handleSubmit.bind(this)}
        className={'no-input-margins'}
      >
        <Trans i18nkey={'notice.character_transfer'}>
          <p>
            If you wish to transfer a character, and all the art assets and
            history attached, enter the destination username or email below.
          </p>
          <p>
            If the user does not have an account, they will be sent an email
            prompting them to create one before accepting this transfer.
          </p>
          <p>
            This character transfer, if accepted, will be recorded in the
            character's history. You will not be able to recall this character.
            All rights to this character's file will be reassigned.
          </p>
        </Trans>

        <Row>
          <TextInput
            s={12}
            name={'destination'}
            id={'transfer_destination'}
            label={t(
              'labels.transfer_destination',
              'Destination Email, Username, or Organization ID'
            )}
            value={this.state.destination}
            onChange={this.handleDestinationChange.bind(this)}
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
              className={'btn btn-primary'}
              disabled={!this.state.destination}
            >
              {t('actions.transfer', 'Transfer')}
            </button>
          </Col>
        </Row>
      </form>
    )
  }
}

TransferCharacter.propTypes = {
  character: PropTypes.object.isRequired,
  goTo: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
}

export default compose(withNamespaces('common'))(TransferCharacter)
