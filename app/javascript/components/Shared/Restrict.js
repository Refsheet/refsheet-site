/* global Refsheet */

import React from 'react'
import PropTypes from 'prop-types'
import { connect } from 'react-redux'

const Restrict = ({
  admin,
  patron,
  user,
  currentUser,
  hideAll,
  development,
  invert,
  children,
}) => {
  const { is_admin, is_patron, is_supporter } = currentUser || {}

  let hide = false
  if (hideAll) return null

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

  if (admin && !is_admin) {
    hide = true
  }

  if (patron && !is_patron && !is_supporter) {
    hide = true
  }

  if (invert) {
    hide = !hide
  }

  if (hide) return null
  return children
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
})

export default connect(mapStateToProps)(Restrict)
