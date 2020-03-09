/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.ActionButton = React.createClass({
  componentDidUpdate() {
    return Materialize.Tooltip.init(this.refs.actionButton, {delay: 0, position: 'left'});
  },

  componentDidMount() {
    return Materialize.Tooltip.init(this.refs.actionButton, {delay: 0, position: 'left'});
  },

  componentWillUnmount() {
    const el = Materialize.Tooltip.getInstance(this.refs.actionButton);
    return el.destroy();
  },

  render() {
    let largeClass = '';
    let iconClass = '';

    if (this.props.large) {
      largeClass = ' btn-large red';
      iconClass = ' large';
    }

    return <a className={ 'btn-floating tooltipped waves waves-light ' + this.props.className + largeClass }
        ref='actionButton'
        data-tooltip={ this.props.tooltip }
        href={ this.props.href }
        onClick={ this.props.onClick }
        id={ this.props.id }>

         <i className={ 'material-icons' + iconClass }>{ this.props.icon }</i>
     </a>;
  }
});
