@Container = v1 -> (props) ->
  classNames = ['container']
  classNames.push props.className if props.className
  classNames.push 'container-flex' if props.flex

  sClassNames = []
  sClassNames.push 'section-flex' if props.flex

  `<section id={ props.id } className={ sClassNames.join(' ') }>
      <div className={ classNames.join(' ') }>
          { props.children }
      </div>
  </section>`
