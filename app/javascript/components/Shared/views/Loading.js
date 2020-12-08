import React from 'react'
import PropTypes from 'prop-types'
import Spinner from '../../../v1/shared/material/Spinner'

const Loading = function (props) {
  const classNames = ['modal-page-content']
  if (props.className) {
    classNames.push(props.className)
  }

  return (
    <main className={classNames.join(' ')}>
      <div className="container">
        <Spinner small={props.small} />

        {props.message !== false && <h1>{props.message || 'Loading...'}</h1>}

        {props.children}
      </div>
    </main>
  )
}

Loading.propTypes = {
  message: PropTypes.string,
  className: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.array,
    PropTypes.object,
  ]),
}

export default Loading
