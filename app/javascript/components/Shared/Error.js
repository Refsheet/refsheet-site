/* eslint-disable
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
export default ({ message }) => {
  const classNames = ['modal-page-content']

  return (
    <Main className={classNames.join(' ')}>
      <div className="container">
        <h1>{message}</h1>
      </div>
    </Main>
  )
}
