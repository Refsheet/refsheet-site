@SideNavLink = (props) ->
  `<li>
      <a href={ props.href }>
          <i className='material-icons'>{ props.icon }</i>
          { props.text }
      </a>
  </li>`
