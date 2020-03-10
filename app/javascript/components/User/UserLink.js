import React, { Component } from 'react'
import { createIdentity, identitySourceType } from '../../utils/IdentityUtils'

import IdentityLink from 'v1/shared/identity_link'

// TODO - This passes through to the Global IdentityLink component, please convert to V2 standards.

class UserLink extends Component {
  constructor(props) {
    super(props)
  }

  render() {
    const { user } = this.props
    const identity = createIdentity(this.props)

    const legacyUser = {
      link: identity.path,
      name: identity.name,
      username: identity.username,
      type: identity.type,
      avatarUrl: identity.avatarUrl,
      is_admin: user.is_admin,
      is_patron: user.is_patron,
      is_supporter: user.is_supporter,
    }

    // noinspection JSUnresolvedVariable
    return <IdentityLink to={legacyUser} />
  }
}

UserLink.propTypes = identitySourceType

export default UserLink
