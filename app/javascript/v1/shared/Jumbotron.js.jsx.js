/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Jumbotron = function(props) {
  const classNames = ['jumbotron'];
  if (props.className) { classNames.push(props.className); }

  return <div className={ classNames.join(' ') }>
      <div className='jumbotron-background'>
          <div className='container'>{ props.children }</div>
      </div>
  </div>;
};
