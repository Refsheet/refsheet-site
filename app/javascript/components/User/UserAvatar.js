import React from 'react'
import PropTypes from 'prop-types'
import {userFgColor} from "../../utils/UserUtils";

const UserAvatar = ({user, character}) => {
  const identity = {
    avatarUrl: user.avatar_url,
    name: user.name
  }

  const style = {
    boxShadow: `${userFgColor(user)} 0px 0px 3px 1px`
  }

  return (
    <img className='avatar circle' src={ identity.avatarUrl } alt={ identity.name } style={ style } />
  )
}

UserAvatar.propTypes = {}

export default UserAvatar