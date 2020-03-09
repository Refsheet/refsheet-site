/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS208: Avoid top-level this
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
this.Forums.Card = function(props) {
  let { icon, name, description, threadCount, locked, nsfw, noRp, path, unreadCount } = props;

  if (!description) { description = props.children; }

  const flags = {};
  if (locked) { flags.lock = 'Locked'; }
  if (nsfw) { flags.visibility_hidden = 'NSFW Content'; }
  if (noRp) { flags.person = 'Users only, no RP'; }

  const flagIcons = [];

  for (let flagIcon in flags) {
      const hint = flags[flagIcon];
    flagIcons.push(<Icon title={ hint } key={ hint }>{ flagIcon }</Icon>);
  }


  return <Link to={ '/v2' + path } className='block'>
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
  </Link>;
};
