/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.NagBar = React.createClass({
  contextTypes: {
    environment: React.PropTypes.string
},

  _handleClear(e) {
    Cookies.set('_noNagPlease', 1);
    $(this.refs.nag).fadeOut();
    return e.preventDefault();
},

  render() {
    let actionButton;
    if ((this.context.environment === 'test') || Cookies.get('_noNagPlease')) { return null; }

    const { children, action, type } = this.props;

    if (action) {
      actionButton =
        <Button href={ action.href } target='_blank' className='right white-text teal'>{ action.text }</Button>;
  }

    const classNames = ['nag-bar', 'white-text'];

    switch (type) {
      case 'good': classNames.push('teal darken-1'); break;
      case 'bad':  classNames.push('red darken-1'); break;
      case 'info': classNames.push('cyan darken-1'); break;
      default: classNames.push('blue-grey darken 1');
    }

    return <div className={ classNames.join(' ') } ref='nag'>
        <div className='container'>
            <a href='#' className='nag-clear white-text' onClick={ this._handleClear }>
                <Icon className='white-text'>close</Icon>
            </a>

            <div className='nag-content'>
                { children }
            </div>

            <div className='nag-action'>
                { actionButton }
            </div>
        </div>
    </div>;
}
});
