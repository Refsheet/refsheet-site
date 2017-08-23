@Container = (props) ->
  classNames = ['container']
  classNames.push props.className if props.className

  `<section id={ props.id }>
      <div className={ classNames.join(' ') }>
          { props.children }
      </div>
  </section>`
