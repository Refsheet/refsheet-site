@UserCharacterGroups = React.createClass
  propTypes:
    userLink: React.PropTypes.string.isRequired
    groups: React.PropTypes.array.isRequired
    editable: React.PropTypes.bool
    totalCount: React.PropTypes.number
    onChange: React.PropTypes.func


  render: ->
    { onChange, editable } = @props
    dragging = false

    if @props.groups.length
      groups = @props.groups.map (group) ->
        `<UserCharacterGroupLink group={ group }
                                 editable={ editable }
                                 onChange={ onChange }
                                 key={ group.slug } />`

    `<div>
        <ul className='character-group-list'>
            <li className={ 'all' + (!window.location.hash ? ' active' : '') }>
                <i className='material-icons left folder'>person</i>
                <Link to={ this.props.userLink } className='name'>All Characters</Link>
                <span className='count'>{ NumberUtils.format(this.props.totalCount) }</span>
            </li>

            { groups }

            { editable &&
                <UserCharacterGroupForm onChange={ this.props.onChange } /> }

            { dragging &&
                <UserCharacterGroupTrash /> }
        </ul>

        <div className='hint'>
            <div className='strong'>Hint:</div>
            <div className='text'>Drag groups and characters to rearrange. Drag characters to add them to groups.</div>
        </div>
    </div>`
