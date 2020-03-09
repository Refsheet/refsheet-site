@Advertisement = React.createClass

  dataPath: '/our_friends/next'

  getInitialState: ->
    campaign: null

  componentDidMount: ->
    StateUtils.load @, 'campaign'


  _handleImageLoad: (e) ->
    ahoy.track 'advertisement.impression',
               advertisement_id: @state.campaign.id,
               image_file_name: e.target.src,
               current_slot_id: @state.campaign.current_slot_id

  _handleLinkClick: (e) ->
    ahoy.track 'advertisement.click',
               advertisement_id: @state.campaign.id

  _generateLink: ->
    'https://ref.st/l/' + @state.campaign.id

  render: ->
    return null unless @state.campaign
    { title, caption, link, image_url } = @state.campaign

    imageSrc = image_url.medium + '?c=' + Math.floor(Date.now() / 1000)

    `<div className='sponsored-content margin-bottom--large'
          style={{
              boxSizing: 'border-box',
              overflow: 'hidden',
              fontSize: '0.8rem',
              padding: '0 0 1rem 0'
          }}
    >
        <div className='sponsor-blurb'
             style={{
                 fontSize: '0.9rem',
                 color: 'rgba(255, 255, 255, 0.3)',
                 paddingBottom: '0.2rem',
                 marginBottom: '1rem',
                 borderBottom: '1px solid rgba(255, 255, 255, 0.1)'
             }}
        >
            From our Friends:
        </div>

        <div className='blurb-container'
             style={{
                 maxWidth: 220,
                 margin: '0 auto',
                 textAlign: 'center'
             }}
        >
            <a href={ this._generateLink() }
               target='_blank'
               onClick={ this._handleLinkClick }

            >
                <img className='responsive-img'
                     src={ imageSrc }
                     alt={ title }
                     width='200px'
                     height='150px'
                     onLoad={ this._handleImageLoad }
                />
            </a>

            <a href={ this._generateLink() }
               target='_blank'
               className='grey-text text-darken-2 block'
               onClick={ this._handleLinkClick }
               style={{
                   textDecoration: 'underline',
                   fontSize: '0.9rem',
                   marginBottom: '0.3rem',
                   marginTop: '0.5rem'
               }}
            >{ title }</a>

            <div className='sponsor-blurb grey-text text-darken-2'>
                { caption.substring(0,90) }
            </div>
        </div>
    </div>`
