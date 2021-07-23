/* do-not-disable-eslint
    react/display-name,
    react/jsx-no-undef,
    react/prop-types,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
import React from 'react'
import Main from './Main'

const findError = error => {
  if (typeof error === 'undefined') {
    return 'Unknown Error'
  } else if (error.map) {
    return error.map(findError).join(', ')
  } else {
    return error.toString()
  }
}

export default ({ error, message }) => {
  const classNames = ['modal-page-content']

  let finalText = message
  if (!finalText) {
    finalText = findError(error)
  }

  return (
    <Main className={classNames.join(' ')}>
      <div className="container">
        <h1>{finalText}</h1>
      </div>
    </Main>
  )
}
