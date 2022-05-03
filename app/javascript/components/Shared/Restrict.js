/* global Refsheet */

import React from 'react'
import PropTypes from 'prop-types'
import { connect, useSelector } from 'react-redux'

const restrict = ({
  tag = '',
  admin,
  patron,
  user,
  confirmed,
  currentUser,
  hideAll,
  development,
  invert,
  nsfw,
  nsfwOk,
}) => {
  const { currentUser: stateUser } = useSelector(state => state.session)
  const { is_admin, is_patron, is_supporter, email_confirmed_at } =
    currentUser || stateUser || {}

  console.log({
    tag,
    userFlags: { is_admin, is_patron, is_supporter, email_confirmed_at },
    restrictFlags: {
      admin,
      patron,
      user,
      confirmed,
      hideAll,
      development,
      invert,
      nsfw,
      nsfwOk,
    },
  })

  let hide = false
  if (hideAll) return false

  if (
    development &&
    typeof Refsheet !== 'undefined' &&
    Refsheet.environment !== 'development'
  ) {
    hide = true
  }

  if (user && !currentUser) {
    hide = true
  }

  if (confirmed && !email_confirmed_at) {
    hide = true
  }

  if (!is_admin) {
    if (admin) {
      hide = true
    }

    if (patron && !is_patron && !is_supporter) {
      hide = true
    }
  }

  if (nsfw && !nsfwOk) {
    hide = true
  }

  if (invert) {
    hide = !hide
  }

  return !hide
}

const Restrict = ({ children, ...props }) => {
  if (restrict(props)) {
    return children
  } else {
    return null
  }
}

Restrict.propTypes = {
  admin: PropTypes.bool,
  patron: PropTypes.bool,
  hideAll: PropTypes.bool,
  development: PropTypes.bool,
  invert: PropTypes.bool,
}

const mapStateToProps = state => ({
  currentUser: state.session.currentUser,
  nsfwOk: state.session.nsfwOk,
})

export { restrict }
export default connect(mapStateToProps)(Restrict)
