import React from 'react'
import { Link } from 'react-router-dom'
import PropTypes from 'prop-types'
import { userFgColor } from '../../utils/UserUtils'
import { createIdentity } from '../../utils/IdentityUtils'

const UserLink = props => {
  const { user } = props
  const identity = createIdentity(props)

  const style = {
    color: `${userFgColor(user)}`,
  }

  return (
    <Link
      to={identity.path}
      title={`${identity.type}: ${identity.name}`}
      style={style}
    >
      {identity.name}
    </Link>
  )
}

UserLink.propTypes = {
  user: PropTypes.shape({
    username: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    is_admin: PropTypes.bool,
    is_patron: PropTypes.bool,
  }),
}

export default UserLink
