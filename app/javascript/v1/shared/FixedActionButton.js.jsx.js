/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.FixedActionButton = React.createClass({
  componentDidMount(e) {
    return $('.fixed-action-btn').floatingActionButton();
  },

  render() {
    const children = React.Children.map(this.props.children, child => {
      return <li>{ React.cloneElement(child) }</li>;
    });
      
    let className = 'fixed-action-btn';
    if (this.props.clickToToggle) { className += ' click-to-toggle'; }

    return <div className={ className }>
        <ActionButton large={ true } {...this.props} />
        <ul>
            { children }
        </ul>
    </div>;
  }
});
