@Forums.Card = (props) ->
  { icon, name, description, threadCount, locked, nsfw, noRp, path } = props

  description ||= props.children

  flags = {}
  flags.lock = 'Locked' if locked
  flags.visibility_hidden = 'NSFW Content' if nsfw
  flags.person = 'Users only, no RP' if noRp

  flagIcons = []

  for flagIcon, hint of flags
    flagIcons.push `<Icon title={ hint } key={ hint }>{ flagIcon }</Icon>`


  `<Link to={ path } className='block'>
      <div className='card summary-card'>
          <div className='card-image'>
              <Icon>{ icon || 'forum' }</Icon>
          </div>

          <div className='card-stacked'>
              <div className='card-content'>
                  <div className='card-title' title={ name }>{ name || 'Untitled' }</div>
                  <div className='card-flags'>
                      { NumberUtils.format(threadCount || 0) } threads
                      { flags && <span> &bull; </span> }
                      { flagIcons }
                  </div>

                  <div className='description'>
                      { description || 'No description available.' }
                  </div>
              </div>
          </div>
      </div>
  </Link>`
