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
this.Tab = React.createClass({
  propTypes: {
    id: React.PropTypes.string.isRequired,
    name: React.PropTypes.string,
    icon: React.PropTypes.string,
    count: React.PropTypes.number,
    className: React.PropTypes.string,
  },

  render() {
    const classNames = ['tab-content']
    if (this.props.className) {
      classNames.push(this.props.className)
    }

    return (
      <div className={classNames.join(' ')} id={this.props.id}>
        {this.props.children}
      </div>
    )
  },
})
