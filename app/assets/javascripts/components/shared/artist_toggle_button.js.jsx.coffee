@ArtistToggleButton = (props) ->
  `<Link to={ props.linkTo } params={ props.linkParams } className='side-nav-trigger tooltipped' data-tooltip={ props.tooltip } data-position='right'>
     <i className='material-icons'>{ props.icon }</i>
  </Link>`
