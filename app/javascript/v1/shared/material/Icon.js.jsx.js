/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Icon = function(props) {
  const { children, title, className, style } = props;
  const classNames = ['material-icons'];
  if (className) { classNames.push(className); }

  return <i className={ classNames.join(' ') } title={ title } style={ style }>{ children }</i>;
};
