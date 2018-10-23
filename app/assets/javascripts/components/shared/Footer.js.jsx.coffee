@Footer = (props) ->
  `<footer className="page-footer grey darken-4">
      <div className='container margin-top--large'>
          <Row>
              <Column s={12} m={4}>
                  <div className='caption white-text'>Refsheet.net</div>
                  <p>
                    A new, convenient way to organize your character designs, art and world.
                    All of this supported by <a href='https://www.patreon.com/refsheet' target='_blank'>Patreon</a>!
                  </p>
                  <div className='muted'>Copyright &copy;2018 Refsheet.net</div>
              </Column>

              <Column s={12} m={2} />

              <Column s={12} m={2}>
                <ul className='margin-top--none'>
                  <li><Link to='/'>Home</Link></li>
                  <li><Link to='/browse'>Characters</Link></li>
                  <li><Link to='/explore'>Images</Link></li>
                  <li><Link to='/forums'>Forums</Link></li>
                </ul>
              </Column>

              <Column s={12} m={3}>
                  <div className='social-links'>
                      <a href='https://twitter.com/Refsheet' target='_blank'>
                          <i className='fa fa-fw fa-twitter' />
                      </a>
                      <a href='https://www.patreon.com/refsheet' target='_blank'>
                          <img src='/assets/third_party/patreon_white.png' alt='Patreon' />
                      </a>
                  </div>

                <ul>
                  <li><Link to='/terms'>Terms</Link></li>
                  <li><Link to='/privacy'>Privacy</Link></li>
                  <li><Link to='/static/changelog'>Changelog</Link></li>
                </ul>
              </Column>

              <Column s={12} m={1}>
                <ul className='right-align margin-top--none'>
                  <li><a class="white-text" href="/?locale=en">English</a></li>
                  <li><a class="grey-text" href="/?locale=de">Deutsch</a></li>
                  <li><a class="grey-text" href="/?locale=es">Español</a></li>
                  <li><a class="grey-text" href="/?locale=ru">Русский</a></li>
                  <li><a class="grey-text" href="/?locale=ja">日本語</a></li>
                </ul>
              </Column>
          </Row>
      </div>
      {/*<Section className="footer-copyright">*/}
          {/*<Row>*/}
              {/*<Column s='12' m='6'>*/}
                  {/*&copy;2017 // A Sitehive project*/}
              {/*</Column>*/}

              {/*<Column s='12' m='6' className='right-align'>*/}
                  {/*<Link to='/terms'>Terms</Link> | <Link to='/privacy'>Privacy</Link>*/}
              {/*</Column>*/}
          {/*</Row>*/}
      {/*</Section>*/}
  </footer>`
