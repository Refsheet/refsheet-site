@Footer = (props) ->
  `<footer className="page-footer">
      <div className='container'>
          <Row>
              <Column s={12} m={6}>
                  <h5>Refsheet.net</h5>
                  <p>A new, convenient way to organize your character designs, art and world.</p>
              </Column>

              <Column s={12} m={6}>
                  <div className='social-links'>
                      <a href='https://twitter.com/Refsheet'>
                          <i className='fa fa-fw fa-twitter' />
                      </a>
                      <a href='https://www.patreon.com/refsheet'>
                          <img src='/assets/third_party/patreon_white.png' alt='Patreon' />
                      </a>
                  </div>

                  <ul>
                      <li><Link to='/browse'>Browse</Link></li>
                  </ul>
              </Column>
          </Row>
      </div>
      <Section className="footer-copyright">
          <Row>
              <Column s='12' m='6'>
                  &copy;2017 // A Sitehive project
              </Column>
              <Column s='12' m='6' className='right-align'>
                  Privacy | DMCA | Terms
              </Column>
          </Row>
      </Section>
  </footer>`
