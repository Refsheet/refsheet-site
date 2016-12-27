@CharacterCard = (props) ->
  `<div className='character-card'>
      <div className='row'>
          <div className='col l8 m7 s12'>
              <div className='character-details'>
                  <h1 className='name'>{ props.name }</h1>

                  <div className='description'>
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
                  </div>

                  <div className='actions'>
                      <a href='#' className='btn z-index-1'>+ Follow</a>
                  </div>
              </div>
          </div>

          <div className='col l4 m5 s12'>
              <div className='character-image'>
                  <div className='slant' />
                  <img src={ props.imageSrc } />
              </div>
          </div>
      </div>
  </div>`
