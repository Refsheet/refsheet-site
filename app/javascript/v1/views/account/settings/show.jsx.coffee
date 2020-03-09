namespace 'Views.Account.Settings'

class @Views.Account.Settings.Show extends React.Component
  @contextTypes:
    currentUser: React.PropTypes.object.isRequired
    setCurrentUser: React.PropTypes.func.isRequired

  constructor: (props, context) ->
    @state =
      user: context.currentUser

    super props


  _handleFormChange: (user) =>
    @context.setCurrentUser user
    Materialize.toast({ html: "Settings Saved", displayLength: 3000, classes: 'green' })


  render: ->
    `<div className='account-settings'>
        <Form action={ this.state.user.path }
              className='card sp'
              method='PATCH'
              onChange={ this._handleFormChange }
              model={ this.state.user }
              modelName='user'>

            <div className='card-header'>
                <h2>User Settings</h2>
            </div>

            <div className='card-content padding-bottom--none'>
                <Row noMargin>
                    <Column m={6}>
                        <Input name='name' type='text' label='Display Name' />
                    </Column>

                    <Column m={6}>
                        <Input name='email' type='email' label='Email Address' />
                    </Column>
                </Row>

                <Row noMargin>
                    <Column m={6}>
                        <Input name='username' type='text' label='Username' />
                    </Column>

                    <Column m={6}>
                        <div className='padding-top--small strong red-text text-darken-1'>
                            Warning!
                        </div>

                        <div className='muted'>
                            Changing your username will break any links to your account.
                        </div>
                    </Column>
                </Row>
            </div>

            <div className='card-action right-align'>
                <Submit>Save Settings</Submit>
            </div>
        </Form>

        <Form action={ this.state.user.path }
              className='card sp margin-top--large'
              method='PATCH'
              onChange={ this._handleFormChange }
              model={ this.state.user }
              modelName='user'>

            <div className='card-header'>
                <h2>Change Password</h2>
            </div>

            <div className='card-content padding-bottom--none'>
                <Row noMargin>
                    <Column m={6}>
                        <Input name='password' type='password' placeholder='Change Password' />
                    </Column>

                    <Column m={6}>
                        <Input name='password_confirmation' type='password' placeholder='Password Confirmation' />
                    </Column>
                </Row>
            </div>

            <div className='card-action right-align'>
                <Submit>Change Password</Submit>
            </div>
        </Form>

        <Packs.application.DeleteUser user={ this.state.user } />
    </div>`
