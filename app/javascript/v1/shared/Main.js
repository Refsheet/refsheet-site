/* eslint-disable
    no-undef,
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
this.Main = React.createClass({
  propTypes: {
    style: React.PropTypes.object,
    className: React.PropTypes.string,
    bodyClassName: React.PropTypes.string,
    fadeEffect: React.PropTypes.bool,
    slideEffect: React.PropTypes.bool,
    id: React.PropTypes.string,
    title: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.array,
    ]),
  },

  _updateTitle(title) {
    const titles = []
    titles.push(title)
    titles.push('Refsheet.net')
    return (document.title = [].concat.apply([], titles).join(' - '))
  },

  componentWillMount() {
    if (this.props.title && this._updateTitle) {
      this._updateTitle(this.props.title)
    }

    return $('body').addClass(this.props.bodyClassName)
  },

  componentWillReceiveProps(newProps) {
    if (newProps.title && this._updateTitle) {
      this._updateTitle(newProps.title)
    }

    if (newProps.bodyClassName !== this.props.bodyClassName) {
      $('body').removeClass(this.props.bodyClassName)
      return $('body').addClass(newProps.bodyClassName)
    }
  },

  componentDidMount() {
    if (this.props.fadeEffect) {
      $(this.refs.main).fadeIn()
    }

    if (this.props.slideEffect) {
      return $(this.refs.main).slideDown()
    }
  },

  componentWillUnmount() {
    return $('body').removeClass(this.props.bodyClassName)
  },

  render() {
    const style = this.props.style || {}
    const classNames = [this.props.className]
    if (this.props.flex) {
      classNames.push('main-flex')
    }

    if (this.props.fadeEffect || this.props.slideEffect) {
      style.display = 'none'
    }

    return (
      <main
        style={this.props.style}
        id={this.props.id}
        className={classNames.join(' ')}
        ref="main"
      >
        {this.props.children}
      </main>
    )
  },
})
