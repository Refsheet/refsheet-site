import React, { Component } from 'react'
import PropTypes from 'prop-types'
import * as ReactGA from 'react-ga'
import Main from '../../shared/Main'
import Form from '../../shared/forms/Form'
import Input from '../../shared/forms/Input'
import Submit from '../../shared/forms/Submit'
import $ from 'jquery'
import Flash from '../../../utils/Flash'
import { Link } from 'react-router-dom'
import compose, { withConfig, withCurrentUser } from '../../../utils/compose'
import ReCAPTCHA from 'react-google-recaptcha'
import { withRouter } from 'react-router'
import { Checkbox } from 'react-materialize'

class RegisterView extends Component {
  constructor(props) {
    super(props)

    this.captchaRef = React.createRef()

    this.state = {
      user: {
        username: this.props.location.query.username,
        email: null,
        password: null,
        password_confirmation: null,
      },
      extra: {
        captchaData: null,
        tosAgree: false,
      },
    }

    this.handleCaptchaChange = this.handleCaptchaChange.bind(this)
    this.handleTosAgree = this.handleTosAgree.bind(this)
  }

  _handleChange(user) {
    ReactGA.event({
      category: 'User',
      action: 'Sign Up',
    })

    Flash.info(
      'Thank you for registering! Please check your email for confirmation.'
    )

    this.props.setCurrentUser(user)
    this.props.history.push('/')
  }

  componentDidMount() {
    return $('body').addClass('no-footer')
  }

  componentWillUnmount() {
    return $('body').removeClass('no-footer')
  }

  handleCaptchaChange(data) {
    this.setState({
      ...this.state,
      extra: {
        ...this.state.extra,
        captchaData: data,
      },
    })
  }

  _handleError(e) {
    this.captchaRef.current && this.captchaRef.current.reset()
  }

  handleTosAgree(e) {
    this.setState({
      ...this.state,
      extra: {
        ...this.state.extra,
        tosAgree: e.target.checked,
      },
    })
  }

  render() {
    const { config } = this.props

    return (
      <Main title="Register" className="modal-page-content shaded-background">
        <div className="modal-page-content">
          <div className="narrow-container">
            <h1>Register</h1>

            <Form
              action="/users"
              method="POST"
              formName={'register_full'}
              model={this.state.user}
              extraData={this.state.extra}
              onChange={this._handleChange.bind(this)}
              onError={this._handleError.bind(this)}
              modelName="user"
            >
              <Input
                name="username"
                value={this.state.username}
                label="Username"
                autoFocus
              />

              <Input
                name="email"
                type="email"
                value={this.state.email}
                label="Email"
              />

              <Input
                name="password"
                value={this.state.password}
                type="password"
                label="Password"
              />

              <Input
                name="password_confirmation"
                value={this.state.password_confirmation}
                type="password"
                label="Confirm Password"
              />

              {config.recaptchaSiteKey && (
                <React.Fragment>
                  <ReCAPTCHA
                    ref={this.captchaRef}
                    sitekey={config.recaptchaSiteKey}
                    theme={'dark'}
                    onChange={this.handleCaptchaChange}
                  />
                  <div className={'muted margin-top--small'}>
                    ^- We &lt;3 all robotic creatures, but we must ensure that
                    you are a good, sentient robot.
                  </div>
                </React.Fragment>
              )}

              <div className={'tos margin-top--large padding-bottom--large'}>
                <p>
                  <strong>One more thing,</strong> when you use this site, you
                  have to follow the rules listed in our{' '}
                  <a href={'/terms'} rel="noreferrer" target={'_blank'}>
                    Terms of Service
                  </a>
                  . You must also be over the age of 16. Lastly, you must
                  promise to only ever be excellent to one another when on this
                  site.
                </p>
                <Checkbox
                  id={'tos_agree_or_be_ban'}
                  value={'agree'}
                  checked={this.state.extra.tosAgree}
                  onChange={this.handleTosAgree}
                  label={
                    'I agree to follow the ToS, I am over 16, and I will be excellent to others.'
                  }
                />
              </div>

              <div className="form-actions margin-top--large">
                <Link
                  to="/login"
                  query={{ username: this.state.username }}
                  className="btn grey darken-3"
                >
                  Log In
                </Link>
                <Submit
                  className={'right'}
                  disabled={!this.state.extra.tosAgree}
                >
                  Register
                </Submit>
              </div>
            </Form>
          </div>
        </div>
      </Main>
    )
  }
}

export default compose(
  withCurrentUser(true),
  withRouter,
  withConfig
)(RegisterView)
