import React from 'react'
import { div as Card } from '../../Styled/Card'
import getApiKeys from './getApiKeys.graphql'
import { Query } from 'react-apollo'
import Error from '../../Shared/Error'

const renderKeys = ({ data, error, loading }) => {
  const { getApiKeys = [] } = data || {}

  console.log({ getApiKeys, error, loading })
  if (loading) {
    return <p className={'caption center'}>Loading...</p>
  } else if (error) {
    return <Error error={error} />
  } else if (!getApiKeys || getApiKeys.length === 0) {
    return (
      <p className={'caption center'}>You have not registered any API Keys.</p>
    )
  } else {
    return (
      <table>
        <tr>
          <th>Name</th>
          <th>Permissions</th>
          <th>ID</th>
          <th>Secret (Visible Once)</th>
        </tr>
        {getApiKeys.map(apiKey => (
          <tr key={apiKey.id}>
            <td>{apiKey.name}</td>
            <td>{apiKey.read_only ? 'Read' : 'Write'}</td>
            <td>{apiKey.id}</td>
            <td>{apiKey.secret}</td>
          </tr>
        ))}
      </table>
    )
  }
}

const ApiKeys = () => {
  return (
    <Card className={'card sp'}>
      <div className={'card-header'}>
        <h2>API Keys</h2>
      </div>

      <div className={'card-content'}>
        <Query query={getApiKeys}>{renderKeys}</Query>
      </div>
    </Card>
  )
}

export default ApiKeys
