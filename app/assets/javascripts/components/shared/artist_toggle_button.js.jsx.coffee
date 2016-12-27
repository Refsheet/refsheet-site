@ArtistToggleButton = React.createClass
  onClick: (e) ->
    @props.onChange(!@props.artistView)
    e.preventDefault()

  componentDidUpdate: ->
    $('.side-nav-trigger').tooltip()

  render: ->
    if @props.artistView
      icon = 'perm_identity'
      tooltip = 'Change to User View'
    else
      icon = 'brush'
      tooltip = 'Change to Artist View'
    
    `<a className='side-nav-trigger tooltipped' onClick={ this.onClick } data-tooltip={ tooltip } data-position='right' >
        <i className='material-icons'>{ icon }</i>
    </a>`
