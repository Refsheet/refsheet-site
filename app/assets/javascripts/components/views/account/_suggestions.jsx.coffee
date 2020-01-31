@Views.Account.Suggestions = v1 -> React.createClass
  getInitialState: ->
    suggested: null

  dataPath: '/users/suggested'

  componentDidMount: ->
    StateUtils.load @, 'suggested', undefined, undefined, urlParams: limit: 6

  _handleFollow: (f, id) ->
    HashUtils.findItem @state.suggested, id, (u) ->
      u.followed = f
      StateUtils.updateItem @, 'suggested', u

  render: ->
    return null unless @state.suggested

    suggestions = @state.suggested.map (user) ->
      `<li className='collection-item margin-bottom--small'
           style={{ padding: '0.5rem 0' }}
           key={ user.username }
      >
          <Views.Account.UserCard user={ user }
                                  onFollow={ this._handleFollow }
                                  smaller />
      </li>`

    `<ul className='collection-flat' style={{ marginTop: 0, marginBottom: '3rem' }}>
        <li className='subheader'
            style={{
                fontSize: '0.9rem',
                color: 'rgba(255, 255, 255, 0.3)',
                paddingBottom: '0.2rem',
                marginBottom: '0.25rem',
                borderBottom: '1px solid rgba(255, 255, 255, 0.1)'
            }}
        >
            You may like...
        </li>

        { suggestions }
    </ul>`
