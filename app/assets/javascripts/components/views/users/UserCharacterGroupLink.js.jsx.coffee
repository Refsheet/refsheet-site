@UserCharacterGroupLink = React.createClass
  propTypes: ->
    group: React.PropTypes.object.isRequired
    editable: React.PropTypes.bool
    onChange: React.PropTypes.func

  getInitialState: ->
    edit: false


  _handleEdit: (e) ->
    @setState edit: true
    e.preventDefault()

  _handleChange: (data) ->
    @setState edit: false
    @props.onChange data

  render: ->
    if @state.edit
      `<UserCharacterGroupForm group={ this.props.group }
                               onChange={ this._handleChange } />`

    else
      editable = @props.editable
      active = window.location.hash.substring(1) == @props.group.slug
      classNames = []
      classNames.push 'active' if active

      `<li className={ classNames.join(' ') }>
          <i className='material-icons left folder'>{ active ? 'folder_open' : 'folder' }</i>

          <Link to={ this.props.group.link } className='name'>
              { this.props.group.name }
          </Link>

          <span className='count'>
              { NumberUtils.format(this.props.group.characters_count) }
          </span>

          { editable &&
              <a href='#' onClick={ this._handleEdit } className='action'>
                  <i className='material-icons'>edit</i>
              </a> }
      </li>`
