/* eslint-disable
    no-undef,
    react/no-deprecated,
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
this.Stats = React.createClass({
  propTypes: {
    className: PropTypes.string,
  },

  render() {
    const classNames = ['stats']
    if (this.props.className) {
      classNames.push(this.props.className)
    }

    return <ul className={classNames.join(' ')}>{this.props.children}</ul>
  },
})

this.Stats.Item = React.createClass({
  propTypes: {
    label: PropTypes.string.isRequired,
  },

  render() {
    return (
      <li>
        <div className="label">{this.props.label}</div>
        <div className="value">{this.props.children}</div>
      </li>
    )
  },
})
