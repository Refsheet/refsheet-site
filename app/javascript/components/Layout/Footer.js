/* global Refsheet */

import React, { Component } from 'react'
import compose from '../../utils/compose'
import { Link } from 'react-router-dom'
import { Row, Col } from 'react-materialize'
import Restrict from '../Shared/Restrict'
import i18n from '../../services/i18n'
import c from 'classnames'
import SessionService from '../../services/SessionService'
import { H3 } from '../Styled/Headings'
import styled from 'styled-components'
import { withErrorBoundary } from '../Shared/ErrorBoundary'

class _Footer extends Component {
  constructor(props) {
    super(props)

    this.state = {
      locale: i18n.language,
    }
  }

  componentDidMount() {
    const apply = locale => {
      this.setState({ locale })
    }

    i18n.on('languageChanged', apply.bind(this))
  }

  setLocale(locale) {
    return e => {
      e.preventDefault()
      i18n
        .changeLanguage(locale)
        .then(() => {
          SessionService.set({ locale }).then(console.log).catch(console.error)
        })
        .catch(console.error)
    }
  }

  setTheme(theme) {
    return e => {
      e.preventDefault()
    }
  }

  render() {
    return (
      <footer className={'page-footer ' + this.props.className}>
        <div className="container margin-top--large">
          {Refsheet.environment !== 'test' ? (
            <div>
              <Row>
                <Col s={12}>
                  <H3 className="center">
                    Would you like to support Refsheet.net?
                  </H3>
                  <p>
                    It seems you like this website (or you like scrolling to the
                    bottom of pages)! Did you know that this whole site is
                    developed by <strong>one person</strong> with a tiny army of
                    helpful people? I love making this site possible, but I
                    could use your help.{' '}
                    <strong>Here are 3 really easy ways to help out:</strong>
                  </p>
                  <ul className="browser-default">
                    <li className="padding-bottom--small">
                      <strong>
                        <a
                          href="https://patreon.com/refsheet"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="primary-text"
                        >
                          Patreon!
                        </a>
                      </strong>{' '}
                      Recurring monthly donations help cover the costs of
                      running the website, and one day might pay for other
                      people to help develop, too!
                    </li>
                    <li className="padding-bottom--small">
                      <strong>
                        <a
                          href="https://ko-fi.com/refsheet"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="primary-text"
                        >
                          Buy a Coffee!
                        </a>
                      </strong>{' '}
                      One-time donations through Ko-fi really help, and are a
                      great way to show your appreciation!
                    </li>
                    <li>
                      <strong className="white-text">Spread the word!</strong>{' '}
                      This website is free to use, and spreading the word is a
                      great free way to invite your friends and followers to
                      join. Bonus points if you share our Patreon or Ko-fi links
                      around!
                    </li>
                  </ul>
                  <p>
                    Honestly, without the help and donations I've received so
                    far, this site wouldn't be possible. If you like what you
                    see, and want to see more, I'd really appreciate some help
                    any way you can.
                  </p>
                </Col>
              </Row>

              <hr />
            </div>
          ) : null}

          <Row>
            <Col s={12} m={4}>
              <div className="caption white-text">Refsheet.net</div>
              <p>
                A new, convenient way to organize your character designs, art
                and world. All of this supported by{' '}
                <a
                  href="https://www.patreon.com/refsheet"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Patreon
                </a>
                !
              </p>
            </Col>

            <Col s={12} m={2} />

            <Col s={6} m={2}>
              <ul className="margin-top--none">
                <li>
                  <Link to="/">Home</Link>
                </li>
                <li>
                  <Link to="/browse">Characters</Link>
                </li>
                <Restrict development>
                  <li>
                    <Link to="/artists">Artists</Link>
                  </li>
                </Restrict>
                <li>
                  <Link to="/explore">Images</Link>
                </li>
                <li>
                  <Link to="/forums">Forums</Link>
                </li>
              </ul>
            </Col>

            <Col s={6} m={3}>
              <div className="social-links">
                <a
                  href="https://twitter.com/Refsheet"
                  target="_blank"
                  rel="noopener noreferrer"
                  title={'Follow us on Twitter!'}
                >
                  <i className="fab fa-fw fa-twitter" />
                </a>
                <a
                  href="mailto:mau@refsheet.net"
                  target="_blank"
                  rel="noopener noreferrer"
                  title={'Send an email'}
                >
                  <i className="fa fa-fw fa-envelope" />
                </a>
                <a
                  href={'https://discord.gg/nzdEHub'}
                  target={'_blank'}
                  rel="noopener noreferrer"
                  title={'Join us on Discord!'}
                >
                  <i className={'fab fa-fw fa-discord'} />
                </a>{' '}
                <a
                  href="https://www.patreon.com/refsheet"
                  target="_blank"
                  rel="noopener noreferrer"
                  title={'Support us on Patreon!'}
                >
                  <img
                    src="/assets/third_party/patreon_white.png"
                    alt="Support us on Patreon!"
                  />
                </a>
              </div>

              <ul>
                <li>
                  <Link to="/terms">Terms</Link>
                </li>
                <li>
                  <Link to="/privacy">Privacy</Link>
                </li>
                <li>
                  <a href="/api">API</a>
                </li>
              </ul>
            </Col>

            <Col s={12} m={1}>
              <ul className="right-align margin-top--none">
                <li>
                  <a
                    className={c(
                      this.state.locale === 'en' ? 'white-text' : 'grey-text'
                    )}
                    href="/?locale=en"
                    onClick={this.setLocale('en').bind(this)}
                  >
                    English
                  </a>
                </li>
                <li>
                  <a
                    className={c(
                      this.state.locale === 'es' ? 'white-text' : 'grey-text'
                    )}
                    href="/?locale=es"
                    onClick={this.setLocale('es').bind(this)}
                  >
                    Español
                  </a>
                </li>
                <li>
                  <a
                    className={c(
                      this.state.locale === 'pt' ? 'white-text' : 'grey-text'
                    )}
                    href="/?locale=pt"
                    onClick={this.setLocale('pt').bind(this)}
                  >
                    Português
                  </a>
                </li>
                <li>
                  <a
                    className={c(
                      this.state.locale === 'ru' ? 'white-text' : 'grey-text'
                    )}
                    href="/?locale=ru"
                    onClick={this.setLocale('ru').bind(this)}
                  >
                    Русский
                  </a>
                </li>
              </ul>
            </Col>
          </Row>

          <div className="smaller center margin-bottom--large">
            Copyright &copy;2017-2020 Refsheet.net &bull; Version:{' '}
            <a
              href={
                'https://github.com/Refsheet/refsheet-site/tree/' +
                Refsheet.version
              }
              target={'_blank'}
              rel={'noreferrer'}
            >
              {Refsheet.version.substr(0, 7)}
            </a>
            <br />
            Character and user media ownership is subject to the copyright and
            distribution policies of the owner. Use of character and user media
            is granted to Refsheet.net to display and store. Unauthorized
            uploads and media usage may be reported to{' '}
            <a href="mailto:mau@refsheet.net">mau@refsheet.net</a>. See{' '}
            <Link to="/terms">Terms</Link> for more details.
          </div>
        </div>
      </footer>
    )
  }
}

const Footer = styled(_Footer)`
  background-color: ${props => props.theme.cardBackground} !important;
  color: ${props => props.theme.text} !important;
`

export default compose(withErrorBoundary)(Footer)
