@Home = ->
  demoSwatches = [
    { name: 'Light Fur', color: '#fdf2d4' },
    { name: 'Dark Fur', color: '#b5a67e' },
    { name: 'Hair', color: '#402b2b', notes: 'Shades may vary.' },
    { name: 'Eyes', color: '#2a3c1e' }
    { name: 'Markings', color: '#99b734' }
  ]
  `<main>
      <Jumbotron backgroundImage='/assets/unsplash/typewriter.jpg'>
          <h1>Your characters, <strong>organized.</strong></h1>
          <p className='flow-text'>
              Let Refsheet help you commission, share, and socialize
          </p>
          <div className='jumbotron-action'>
              <Link to='/register' className='btn btn-large'>Get Started</Link>
          </div>
      </Jumbotron>

      <section className='pop-out'>
          <div className='container'>
              <div className='flow-text center'>
                  A new, convinient way to organize your character designs and art.
              </div>
          </div>
      </section>

      <section className='padded' id='detailed-reference'>
          <div className='container'>
              <div className='row'>
                  <div className='col m6 s12'>
                      <h1>Detailed Reference</h1>
                      <p>
                          Sampling colors off an image can be ambiguous and confusing. Refsheet removes this confusion
                          by giving character creators an easy-to-use color palette to specify the exact color for each
                          important aspect of your character.
                      </p>
                      <p>
                          Artists can copy the hexadecimal codes into whichever editor they are using, or get a pure sample
                          without any compression or alias artifacts right from the color swatch or color rule.
                      </p>
                  </div>
                  <div className='col m1 s12' />
                  <div className='col m5 s12'>
                      <SwatchPanel swatches={ demoSwatches } expand={ true } />
                  </div>
              </div>
          </div>
      </section>

      <PageHeader backgroundImage='/assets/unsplash/bamboo.jpg'>
          <div className='character-card'>
              <div className='character-details'>
                  <h1 className='real-name'>Beautiful Presentation</h1>
                  <p>
                      Using modern Material design by Google, and a fast, responsive ReactJS powered front-end, your
                      characters will be presented in a beautiful and interactive format, suitable for whichever device
                      is viewing it.
                  </p>
                  <p>
                      Styles are designed to create visual consistency across the site, unifying the presentation of
                      references and making it easier to find the information you need. Each character can set custom
                      colors for their page, balancing unique and uniform styles.
                  </p>
              </div>
              <div className='character-image'>
                  <div className='slant' />
                  <img src='/assets/unsplash/yawn.jpg' />
              </div>
          </div>
      </PageHeader>

      <section id='easy-to-use' className='padded-bottom'>
          <div className='container'>
              <div className='row'>
                  <div className='col m5 s12'>
                      <div className='card-panel'>
                          <h2 className='name'>James the Hunter</h2>
                          <AttributeTable onAttributeUpdate={ function(e, cb) { if(cb) { cb(e) } } } sortable={ true } hideNotesForm={ true } freezeName='true'>
                              <Attribute name='Name' value='James the Hunter' />
                              <Attribute name='Species' value='Humanoid' />
                              <Attribute name='Age' value='135 years' />
                              <Attribute name='Favorite Color' value={ null } />
                          </AttributeTable>
                      </div>
                  </div>

                  <div className='col m6 offset-m1 s12'>
                      <h1>Easy to Use</h1>
                      <p>
                          The hard part was making the character, documenting it should be easy. This is why we offer
                          in-place editing on many fields without the need to ever reload a page.
                      </p>
                      <p>
                          Go ahead and give James over there a favorite color. (It won't save, though, James the Hunter
                          isn't a real character. Perhaps you should <Link to='/register'>make your own?</Link>)
                      </p>
                  </div>
              </div>
          </div>
      </section>

      <section className='pop-out'>
          <div className='container center'>
              <h2>Ready to show off your characters?</h2>
              <Link to='/register' className='btn'>Sign Up</Link>
          </div>
      </section>
  </main>`
