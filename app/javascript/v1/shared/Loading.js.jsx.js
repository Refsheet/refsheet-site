/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Loading = function(props) {
  const classNames = ['modal-page-content'];
  if (props.className) { classNames.push(props.className); }

  return <main className={ classNames.join(' ') }>
      <div className='container'>
          <Spinner small={ props.small } />

          { props.message !== false &&
              <h1>{ props.message || 'Loading...' }</h1>
          }

          { props.children }
      </div>
  </main>;
};
