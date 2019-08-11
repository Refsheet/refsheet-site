import React from 'react'
import { Link } from 'react-router-dom'
import PropTypes from 'prop-types'

const UserLink = ({user: { username, name, is_admin, is_patron }}) => (
  <Link to={`/${username}`} title={`User: ${name}`}>{ name }</Link>
)

UserLink.propTypes = {
  user: PropTypes.shape({
    username: PropTypes.string.isRequired,
    name: PropTypes.string.isRequired,
    is_admin: PropTypes.bool,
    is_patron: PropTypes.bool
  })
}

export default UserLink