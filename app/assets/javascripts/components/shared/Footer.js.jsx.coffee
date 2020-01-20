@Footer = (props) ->
  `<footer className="page-footer grey darken-4">
      <div className='container margin-top--large'>
          <Row>
            <Column s={12} l={8} offset-l={2} m={10} offset-m={1} className='grey-text text-lighten-1'>
              <h2 className='primary-text center'>Would you like to support Refsheet.net?</h2>
              <p>
                It seems you like this website (or you like scrolling to the bottom of pages)! Did you know that this
                whole site is developed by <strong className='white-text'>one person</strong> with a tiny army of helpful people? I love
                making this site possible, but I could use your help. <strong className='white-text'>Here are 3 really easy ways to help out:</strong>
              </p>
              <p>
                <ul className='browser-default'>
                  <li className='padding-bottom--small'>
                    <strong><a href='https://patreon.com/refsheet' target='_blank' className='primary-text'>Patreon!</a></strong>{' '}
                    Recurring monthly donations help cover the costs of running the website, and one day might pay
                    for other people to help develop, too!
                  </li>
                  <li className='padding-bottom--small'>
                    <strong><a href='https://ko-fi.com/refsheet' target='_blank' className='primary-text'>Buy a Coffee!</a></strong>{' '}
                    One-time donations through Ko-fi really help, and are a great way to show your appreciation!
                  </li>
                  <li>
                    <strong className='white-text'>Spread the word!</strong>{' '}
                    This website is free to use, and spreading the word is a great free way to invite your friends
                    and followers to join. Bonus points if you share our Patreon or Ko-fi links around!
                  </li>
                </ul>
              </p>
              <p>
                Honestly, without the help and donations I've received so far, this site wouldn't be possible. If you
                like what you see, and want to see more, I'd really appreciate some help any way you can.
              </p>
            </Column>
          </Row>
        <hr />
          <Row>
              <Column s={12} m={4}>
                  <div className='caption white-text'>Refsheet.net</div>
                  <p>
                    A new, convenient way to organize your character designs, art and world.
                    All of this supported by <a href='https://www.patreon.com/refsheet' target='_blank'>Patreon</a>!
                  </p>
              </Column>

              <Column s={12} m={2} />

              <Column s={6} m={2}>
                <ul className='margin-top--none'>
                  <li><Link to='/'>Home</Link></li>
                  <li><Link to='/browse'>Characters</Link></li>
                  <Restrict development>
                    <li><Link to='/artists'>Artists</Link></li>
                  </Restrict>
                  <li><Link to='/explore'>Images</Link></li>
                  <li><Link to='/forums'>Forums</Link></li>
                </ul>
              </Column>

              <Column s={6} m={3}>
                  <div className='social-links'>
                      <a href='https://twitter.com/Refsheet' target='_blank'>
                          <i className='fab fa-fw fa-twitter' />
                      </a>
                      <a href='mailto:mau@refsheet.net' target='_blank'>
                          <i className='fa fa-fw fa-envelope' />
                      </a>{' '}
                      <a href='https://www.patreon.com/refsheet' target='_blank'>
                          <img src='/assets/third_party/patreon_white.png' alt='Patreon' />
                      </a>
                  </div>

                <ul>
                  <li><Link to='/terms'>Terms</Link></li>
                  <li><Link to='/privacy'>Privacy</Link></li>
                  <li><a href='/api'>API</a></li>
                </ul>
              </Column>

              <Column s={12} m={1}>
                <ul className='right-align margin-top--none'>
                  {/* TODO: Change locale selector to dynamic load. */}
                  <li><a className="white-text" href="/?locale=en">English</a></li>
                  <li><a className="grey-text" href="/?locale=es">Español</a></li>
                  <li><a className='grey-text' href='/?locale=pt'>PT</a></li>
                  <li><a className="grey-text" href="/?locale=ru">Русский</a></li>
                </ul>
              </Column>
          </Row>

        <div className='smaller center margin-bottom--large'>
          Copyright &copy;2017-2020 Refsheet.net &bull; Version: { Refsheet.version }<br/>
          Character and user media ownership is subject to the copyright and
          distribution policies of the owner. Use of character and user media is granted to Refsheet.net to display
          and store. Unauthorized uploads and media usage may be reported to <a href='mailto:mau@refsheet.net'>mau@refsheet.net</a>.
          See <Link to='/terms'>Terms</Link> for more details.
        </div>
      </div>
  </footer>`
