import React from 'react'
import PropTypes from 'prop-types'
import {connect} from "react-redux";

const Restrict = ({admin, patron, currentUser, children}) => {
  const {
    is_admin,
    is_patron
  } = (currentUser || {})

  const hide = (
    admin && !is_admin ||
    patron && !is_patron
  )

  if (hide) return null
  return children
}

Restrict.propTypes = {
  admin: PropTypes.bool,
  patron: PropTypes.bool
}

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser
})

export default connect(mapStateToProps)(Restrict)