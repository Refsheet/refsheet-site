import React, { useState } from 'react'
import { div as Card } from '../../Styled/Card'
import Button from '../../Styled/Button'
import { Switch } from 'react-materialize'
import PropTypes from 'prop-types'
import InputRow from '../shared/InputRow'
import { withMutations } from '../../../utils/compose'
import createApiKey from './createApiKey.graphql'
import getApiKeys from './getApiKeys.graphql'
import Flash from '../../../utils/Flash'

const GenerateNewKey = ({ createApiKey }) => {
  const defaultKey = {
    read_only: true,
    name: '',
  }

  const [saving, setSaving] = useState(false)
  const [apiKey, setApiKey] = useState(defaultKey)

  const handleSubmit = e => {
    setSaving(true)
    e.preventDefault()

    createApiKey({
      wrapped: true,
      variables: apiKey,
      update: (cache, { data: { createApiKey } }) => {
        const { getApiKeys: apiKeys } = cache.readQuery({
          query: getApiKeys,
        })

        cache.writeQuery({
          query: getApiKeys,
          data: {
            getApiKeys: [...apiKeys, createApiKey],
          },
        })
      },
    })
      .then(data => {
        console.log(data)
        Flash.info(
          'API Key Created. Please copy the secret shown in this page, as it will not be visible again.'
        )
      })
      .finally(() => {
        setSaving(false)
      })
  }

  const handleChange = (value, id) => {
    const name = id.replace('api_key_', '')
    const stateDup = { ...apiKey }
    stateDup[name] = value
    setApiKey(stateDup)
  }

  return (
    <form onSubmit={handleSubmit}>
      <Card className={'card sp'}>
        <div className={'card-header'}>
          <h2>Generate API Key</h2>
        </div>

        <div className={'card-content'}>
          <InputRow
            id={'api_key_name'}
            hint={'For you to identify why you made this key.'}
            label={'Name'}
            onChange={handleChange}
            value={apiKey.name}
          />

          <InputRow
            id={'api_key_read_only'}
            label={'Read Only'}
            hint={'Generates a read-only key that cannot change data.'}
            input={Switch}
            onChange={handleChange}
            value={apiKey.read_only}
          />
        </div>

        <div className={'card-action right-align'}>
          <Button type={'submit'} disabled={saving}>
            {saving ? 'Saving...' : 'Save Key'}
          </Button>
        </div>
      </Card>
    </form>
  )
}

GenerateNewKey.propTypes = {
  createApiKey: PropTypes.func.isRequired,
}

export default withMutations({ createApiKey })(GenerateNewKey)
