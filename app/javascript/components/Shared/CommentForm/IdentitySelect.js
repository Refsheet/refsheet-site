import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { Trans, withTranslation } from 'react-i18next'

class IdentitySelect extends Component {
  constructor(props) {
    super(props)
  }

  handleModalOpen(e) {
    e.preventDefault()
    this.props.onClick()
  }

  render() {
    const { t, name } = this.props

    return (
      <div
        className={'identity-select truncate'}
        style={{ lineHeight: '36px', verticalAlign: 'middle', height: '36px' }}
      >
        <Trans i18nKey={'identity.select-link'}>
          <span
            className={'muted'}
            style={{ lineHeight: '36px', verticalAlign: 'middle' }}
          >
            As:{' '}
          </span>

          <a
            href={'#select-identity'}
            onClick={this.handleModalOpen.bind(this)}
            title={t('identity.change', 'Change Identity')}
            style={{ lineHeight: '36px', verticalAlign: 'middle' }}
          >
            {{ name }}
          </a>
        </Trans>
      </div>
    )
  }
}

IdentitySelect.propTypes = {
  onClick: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
}

export default withTranslation('common')(IdentitySelect)
