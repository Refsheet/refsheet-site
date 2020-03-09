/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Container = function(props) {
  const classNames = ['container'];
  if (props.className) { classNames.push(props.className); }
  if (props.flex) { classNames.push('container-flex'); }

  const sClassNames = [];
  if (props.flex) { sClassNames.push('section-flex'); }

  return <section id={ props.id } className={ sClassNames.join(' ') }>
      <div className={ classNames.join(' ') }>
          { props.children }
      </div>
  </section>;
};
