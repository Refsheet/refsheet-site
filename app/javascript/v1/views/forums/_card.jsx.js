@Forums.Card = (props) ->
  { icon, name, description, threadCount, locked, nsfw, noRp, path, unreadCount } = props

  description ||= props.children

  flags = {}
  flags.lock = 'Locked' if locked
  flags.visibility_hidden = 'NSFW Content' if nsfw
  flags.person = 'Users only, no RP' if noRp

  flagIcons = []

  for flagIcon, hint of flags
    flagIcons.push `<Icon title={ hint } key={ hint }>{ flagIcon }</Icon>`


  `<Link to={ '/v2' + path } className='block'>
      <div className='card summary-card no-margin center'>
          <div className='card-image'>
              <Icon>{ icon || 'forum' }</Icon>

              { unreadCount &&
                  <div className='notification'>{ unreadCount } new</div> }
          </div>

          <div className='card-content'>
              <div className='card-title' title={ name }>{ name || 'Untitled' }</div>

              <div className='description'>
                  { description || 'No description available.' }
              </div>

              <div className='card-flags'>
                  { NumberUtils.format(threadCount || 0) } posts
              </div>
          </div>
      </div>
  </Link>`
