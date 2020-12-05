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
        captchaData: null,
      },
    }
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
      user: {
        ...this.state.user,
        captchaData: data,
      },
    })
  }

  _handleError(e) {
    this.captchaRef.current && this.captchaRef.current.reset()
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
                    onChange={this.handleCaptchaChange.bind(this)}
                  />
                  <div className={'muted margin-top--small'}>
                    ^- We &lt;3 all robotic creatures, but we must ensure that
                    you are a good, sentient robot.
                  </div>
                </React.Fragment>
              )}

              <div className="form-actions margin-top--large">
                <Link
                  to="/login"
                  query={{ username: this.state.username }}
                  className="btn grey darken-3"
                >
                  Log In
                </Link>
                <Submit className={'right'}>Register</Submit>
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
