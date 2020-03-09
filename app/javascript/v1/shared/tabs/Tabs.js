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
 * DS207: Consider shorter variations of null checks
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Tabs = React.createClass({
  propTypes: {
    className: PropTypes.string,
  },

  componentDidMount() {
    $(this.refs.tabs).tabs()
    // https://github.com/Dogfalo/materialize/issues/2102
    return $(document).on('materialize:modal:ready', () =>
      $(window).trigger('resize')
    )
  },
  // We'll try this and see if it works.
  // window.dispatchEvent(new Event('resize'))

  render() {
    let className = 'tabs'
    if (this.props.className) {
      className += ' ' + this.props.className
    }

    const tabs = React.Children.map(this.props.children, child => {
      if ((child != null ? child.type : undefined) === Tab) {
        const liClasses = ['tab']
        if (!child.props.name) {
          liClasses.push('no-name')
        }

        return (
          <li className={liClasses.join(' ')}>
            <a href={'#' + child.props.id}>
              {child.props.icon && (
                <i className="material-icons">{child.props.icon}</i>
              )}

              <span className="name">{child.props.name}</span>

              {child.props.count > 0 && (
                <span className="count">
                  {NumberUtils.format(child.props.count)}
                </span>
              )}
            </a>
          </li>
        )
      } else {
        if (typeof (child != null ? child.type : undefined) !== 'undefined') {
          return console.warn(
            `Children to Tabs should be a Tab, got ${
              child != null ? child.type : undefined
            }.`
          )
        }
      }
    })

    return (
      <div className="tabs-container">
        <ul ref="tabs" className={className}>
          {tabs}
        </ul>

        {this.props.children}
      </div>
    )
  },
})
