@Advertisement = React.createClass
  _handleImageLoad: (e) ->
    ahoy.track 'advertisement.impression', advertisement_id: 0, image_file_name: e.target.src

  render: ->
    imageSrc = '/assets/sandbox/RefsheetAdBanner3.png?c=' + Math.floor(Date.now() / 1000)

    utmParams = {
      utm_source: 'refsheet.net',
      utm_campaign: '2017-mauabata-0',
      utm_medium: 'paid-media'
      utm_content: 'newsfeed-sidebar'
    }

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

        <img className='responsive-img'
             src={ imageSrc }
             alt='Sponsored Content Test'
             width='200px'
             height='150px'
             onLoad={ this._handleImageLoad }
        />

        <a href='#'
           target='_blank'
           className='grey-text text-darken-2 block'
           style={{
               textDecoration: 'underline',
               fontSize: '0.9rem',
               marginBottom: 5
           }}
        >Advertise with us!</a>

        <div className='sponsor-blurb grey-text text-darken-2'>
            { "Help us and help yourself, place your ad in the box above to reach more people.".substring(0,90) }
        </div>
    </div>`
