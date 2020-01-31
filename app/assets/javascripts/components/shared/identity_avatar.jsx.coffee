@IdentityAvatar = v1 -> React.createClass
  propTypes:
    src: React.PropTypes.shape
      link: React.PropTypes.string.isRequired
      name: React.PropTypes.string.isRequired
      username: React.PropTypes.string.isRequired
      type: React.PropTypes.string
      avatar_url: React.PropTypes.string
    avatarUrl: React.PropTypes.string

  render: ->
    to = StringUtils.indifferentKeys @props.src
    to.type ||= 'user'

    if to.is_admin || user?.is_admin
      imgShadow = '0 0 3px 1px #2480C8'
      nameColor = '#2480C8'

    else if to.is_patron || user?.is_patron
      imgShadow = '0 0 3px 1px #F96854'
      nameColor = '#F96854'

    `<img src={ this.props.avatarUrl || to.avatarUrl } alt={ this.props.name || to.name } className='avatar circle' style={{ boxShadow: imgShadow }} height={48} width={48} />`
