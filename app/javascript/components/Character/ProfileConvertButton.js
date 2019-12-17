import React from 'react'
import { Mutation } from 'react-apollo'
import { gql } from 'apollo-client-preset'

const Button = ({ id, convert, onConvert, data }) => {
  const handleConvert = e => {
    e.preventDefault()
    convert({
      variables: { id },
    })
      .then(data => {
        console.log(data)
        onConvert(data)
      })
      .catch(console.error)
  }

  if (data.loading) {
    return (
      <a
        className={
          'btn btn-block margin-bottom--medium grey darken-4 grey-text text-lighten-1 disabled'
        }
      >
        Converting...
      </a>
    )
  }

  return (
    <a
      className={
        'btn btn-block margin-bottom--medium grey darken-4 grey-text text-lighten-3'
      }
      onClick={handleConvert}
    >
      Convert Now
    </a>
  )
}

const CONVERT_PROFILE_MUTATION = gql`
  mutation convertCharacter($id: ID!) {
    convertCharacter(id: $id) {
      version
    }
  }
`

const ProfileConvertButton = props => {
  return (
    <Mutation mutation={CONVERT_PROFILE_MUTATION}>
      {(convert, data) => <Button {...props} convert={convert} data={data} />}
    </Mutation>
  )
}

export default ProfileConvertButton
