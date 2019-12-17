import React from 'react'
import PropTypes from 'prop-types'
import { userFgColor } from '../../utils/UserUtils'
import { createIdentity, identitySourceType } from '../../utils/IdentityUtils'

const UserAvatar = props => {
  const { user, onIdentityChangeClick } = props
  const identity = createIdentity(props)

  const style = {
    boxShadow: `${userFgColor(user)} 0px 0px 3px 1px`,
  }

  return (
    <img
      className="avatar circle"
      src={identity.avatarUrl}
      alt={identity.name}
      style={style}
      onClick={onIdentityChangeClick}
    />
  )
}

UserAvatar.propTypes = identitySourceType

export default UserAvatar
