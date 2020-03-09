/* eslint-disable
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/no-string-refs,
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
this.Row = React.createClass({
  propTypes: {
    hidden: React.PropTypes.bool,
    oneColumn: React.PropTypes.bool,
  },

  componentWillReceiveProps(newProps) {
    if (newProps.hidden !== this.props.hidden) {
      if (newProps.hidden) {
        return $(this.refs.row)
          .hide(0)
          .addClass('hidden')
      } else {
        return $(this.refs.row)
          .fadeIn(300)
          .removeClass('hidden')
      }
    }
  },

  render() {
    let children
    let className = this.props.className || ''
    if (this.props.noMargin) {
      className += ' no-margin'
    }
    if (this.props.hidden) {
      className += ' hidden'
    }
    if (this.props.noGutter) {
      className += ' no-gutter'
    }
    if (this.props.tinyGutter) {
      className += ' tiny-gutter'
    }

    if (this.props.oneColumn) {
      children = <Column>{this.props.children}</Column>
    } else {
      ({ children } = this.props)
    }

    return (
      <div ref="row" className={'row ' + className}>
        {children}
      </div>
    )
  },
})
