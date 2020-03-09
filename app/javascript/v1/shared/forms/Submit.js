/* eslint-disable
    react/display-name,
    react/prop-types,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Submit = function(props) {
  const classNames = ['btn']
  classNames.push(props.className)
  if (!props.noWaves) {
    classNames.push('waves-effect waves-light')
  }
  if (props.flat) {
    classNames.push('btn-flat')
  }
  if (props.link) {
    classNames.push('btn-link')
  }

  return (
    <button type={props.type || 'submit'} className={classNames.join(' ')}>
      {props.children || 'Submit'}
    </button>
  )
}
