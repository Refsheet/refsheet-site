import React from 'react'
import PropTypes from 'prop-types'
import { format } from 'NumberUtils'
import Moment from 'react-moment'

const Stats = ({ children }) => <ul className={'stats'}>{children}</ul>

const Stat = ({ label, value, children, age, numeric }) => {
  let formattedValue = value || children

  if (numeric) {
    formattedValue = format(parseInt(formattedValue) || 0)
  } else if (age) {
    formattedValue = (
      <Moment fromNow unix>
        {formattedValue}
      </Moment>
    )
  }

  return (
    <li className={'stat'}>
      <div className={'value'}>{formattedValue}</div>
      <div className={'label'}>{label}</div>
    </li>
  )
}

Stat.propTypes = {
  label: PropTypes.string.isRequired,
  value: PropTypes.string,
  age: PropTypes.bool,
  numeric: PropTypes.bool,
}

export default Stats
export { Stat }
