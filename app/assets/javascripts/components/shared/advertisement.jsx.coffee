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

  _renderLink: ->
    link = @state.campaign.link

    utmParams = {
      utm_source: 'refsheet.net',
      utm_campaign: @state.campaign.slug,
      utm_medium: 'paid-media'
      utm_content: 'newsfeed-sidebar'
    }

    sep = if link.indexOf('?') >= 0 then '&' else '?'
    [link, $.param(utmParams)].join sep

  render: ->
    return null unless @state.campaign
    { title, caption, link, image_url } = @state.campaign

    imageSrc = image_url.medium + '?c=' + Math.floor(Date.now() / 1000)

    `<div className='sponsored-content center'
          style={{
              boxSizing: 'border-box',
              overflow: 'hidden',
              fontSize: '0.8rem',
              maxWidth: 220,
              padding: '5px 10px 10px',
              borderTop: '1px solid #333',
              borderRadius: 10,
              borderBottom: '1px solid #333',
              margin: '0 auto'
          }}
    >
        <div className='sponsor-blurb grey-text text-darken-2 margin-bottom--small'>
            From our Friends:
        </div>

        <a href={ this._renderLink() }
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

        <a href={ this._renderLink() }
           target='_blank'
           className='grey-text text-darken-2 block'
           onClick={ this._handleLinkClick }
           style={{
               textDecoration: 'underline',
               fontSize: '0.9rem',
               marginBottom: 5
           }}
        >{ title }</a>

        <div className='sponsor-blurb grey-text text-darken-2'>
            { caption.substring(0,90) }
        </div>
    </div>`
