/* eslint-disable
    constructor-super,
    no-constant-condition,
    no-this-before-super,
    no-undef,
    react/jsx-no-undef,
    react/no-deprecated,
    react/react-in-jsx-scope,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
namespace('Views.Account.Settings')

const Cls = (this.Views.Account.Settings.Show = class Show extends React.Component {
  static initClass() {
    this.contextTypes = {
      currentUser: React.PropTypes.object.isRequired,
      setCurrentUser: React.PropTypes.func.isRequired,
    }
  }

  constructor(props, context) {
    {
      // Hack: trick Babel/TypeScript into allowing this before super.
      if (false) {
        super()
      }
      let thisFn = (() => {
        return this
      }).toString()
      let thisName = thisFn.match(
        /return (?:_assertThisInitialized\()*(\w+)\)*;/
      )[1]
      eval(`${thisName} = this;`)
    }
    this._handleFormChange = this._handleFormChange.bind(this)
    this.state = { user: context.currentUser }

    super(props)
  }

  _handleFormChange(user) {
    this.context.setCurrentUser(user)
    return Materialize.toast({
      html: 'Settings Saved',
      displayLength: 3000,
      classes: 'green',
    })
  }

  render() {
    return (
      <div className="account-settings">
        <Form
          action={this.state.user.path}
          className="card sp"
          method="PATCH"
          onChange={this._handleFormChange}
          model={this.state.user}
          modelName="user"
        >
          <div className="card-header">
            <h2>User Settings</h2>
          </div>

          <div className="card-content padding-bottom--none">
            <Row noMargin>
              <Column m={6}>
                <Input name="name" type="text" label="Display Name" />
              </Column>

              <Column m={6}>
                <Input name="email" type="email" label="Email Address" />
              </Column>
            </Row>

            <Row noMargin>
              <Column m={6}>
                <Input name="username" type="text" label="Username" />
              </Column>

              <Column m={6}>
                <div className="padding-top--small strong red-text text-darken-1">
                  Warning!
                </div>

                <div className="muted">
                  Changing your username will break any links to your account.
                </div>
              </Column>
            </Row>
          </div>

          <div className="card-action right-align">
            <Submit>Save Settings</Submit>
          </div>
        </Form>

        <Form
          action={this.state.user.path}
          className="card sp margin-top--large"
          method="PATCH"
          onChange={this._handleFormChange}
          model={this.state.user}
          modelName="user"
        >
          <div className="card-header">
            <h2>Change Password</h2>
          </div>

          <div className="card-content padding-bottom--none">
            <Row noMargin>
              <Column m={6}>
                <Input
                  name="password"
                  type="password"
                  placeholder="Change Password"
                />
              </Column>

              <Column m={6}>
                <Input
                  name="password_confirmation"
                  type="password"
                  placeholder="Password Confirmation"
                />
              </Column>
            </Row>
          </div>

          <div className="card-action right-align">
            <Submit>Change Password</Submit>
          </div>
        </Form>

        <Packs.application.DeleteUser user={this.state.user} />
      </div>
    )
  }
})
Cls.initClass()
