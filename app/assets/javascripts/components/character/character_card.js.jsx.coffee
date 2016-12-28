@CharacterCard = (props) ->
  if props.artistView
    description =
      `<div className='description'>
          <AttributeTable>
              <Attribute name='Gender' value='Male' />
              <Attribute name='Species' value='Caracal, Snow Leopard' />
              <Attribute name='Size' value='Anthro - 6&apos;2&quot; / 135lbs' />
              <Attribute name='Personality' value='Calm, reserved, peaceful, shamanistic.' />
          </AttributeTable>

          <div className='important-notes'>
              <h2>Important Notes:</h2>
              <p>Mau's hair has been knotted into messy dreadlocks. Its coloration comes from a botched
                  red dye job. Please do not draw Mau in modern or sexual settings.</p>
          </div>
      </div>`

    actions =
      `<div>
      </div>`

  else
    description =
      `<div className='description'>
          <p>
              Lorem ipsum dolor sit amet, consectetur adipiscing elit.
              Sed ex metus, dignissim at aliquam a, convallis ac tortor.
              Nulla neque. Aenean sagittis ultrices iaculis. Curabitur
              eleifend purus id lorem dapibus, sed consequat.
          </p>
          <p>
              Praesent nunc nulla, pharetra nec libero ac, vestibulum
              venenatis nisi. Fusce ullamcorper porta malesuada. Phasellus
              quis sem eget augue efficitur laoreet. Integer vitae neque
              a est tincidunt varius eget ac diam. Nullam sodales, orci
              eget fringilla mollis, urna odio commodo.
          </p>
      </div>`

    actions =
      `<div className='actions'>
          <a href='#' className='btn z-index-1'>+ Follow</a>
      </div>`

  if props.nickname
    nickname = `<span className='nickname'> ({ props.nickname })</span>`

  prefixClass = 'title-prefix'
  suffixClass = 'title-suffix'

  if props.officialPrefix
    prefixClass += ' official'

  if props.officialSuffix
    prefixClass += ' official'

  `<div className='character-card'>
      <div className='flex-row'>
          <div className='character-details'>
              <h1 className='name'>
                  <span className={ prefixClass }>{ props.titlePrefix } </span>
                  <span className='real-name'>{ props.name }</span>
                  { nickname }
                  <span className={ suffixClass }> { props.titleSuffix }</span>
              </h1>

              { description }
              { actions }
          </div>
          <div className='character-image'>
              <div className='slant' />
              <img src={ props.imageSrc } />
          </div>
      </div>
  </div>`
