namespace 'Views.Account.Settings'

@Views.Account.Settings.Support = v1 ->
  class C extends React.Component
    @contextTypes:
      currentUser: React.PropTypes.object.isRequired
      setCurrentUser: React.PropTypes.func.isRequired

    constructor: (props, context) ->
      @state =
        user: context.currentUser
        patron: context.currentUser.patron
        lookup:
          lookup_email: context.currentUser.email

      super props


    _handleFormChange: (patron) =>
      console.debug patron
      Materialize.toast({ html: "Settings Saved", displayLength: 3000, classes: 'green' })


    render: ->
      if @state.user.is_patron
        attributes = []

        for k, v of @state.user.patron
          attributes.push \
            `<Attribute key={ k } name={ k } value={ v } />`

        for pledge in @state.user.pledges
          for k, v of pledge
            attributes.push \
              `<Attribute key={ k } name={ k } value={ v } />`

        patreonStatus =
          `<div className='card sp margin-bottom--none'>
              <div className='card-header'>
                  <h2>Patreon Support</h2>
              </div>

              <div className='card-content'>
                  <p>
                      Thank you for supporting us on Patreon! A summary of your
                      support level is shown below.
                      Please visit <a href='https://patreon.com/refsheet' target='_blank'>Patreon.com/Refsheet</a> to
                      manage your pledges.
                  </p>

                  <AttributeTable>
                      { attributes }
                  </AttributeTable>
              </div>
          </div>`

      else
        patreonStatus =
          `<div className='card sp margin-bottom--none'>
              <div className='card-header'>
                  <h2>Patreon Support</h2>
              </div>

              <Form action='/account/support/patron'
                    model={ this.state.lookup }
                    modelName='patron'
                    method='PUT'
                    onChange={ this._handleFormChange }>

                  <div className='card-content padding-bottom--none'>
                      <p>
                          You are not currently a patron. If you would like to become a patron,
                          please visit <a href='https://patreon.com/refsheet' target='_blank'>Patreon.com/Refsheet</a> to
                          pledge your support.
                      </p>
                  </div>

                  <div className='card-content padding-bottom--none'>
                      <p className='margin-bottom--medium'>
                          If you are sure you pledged, and you are seeing this message, please
                          enter the email address that you used on Patreon below, and we will
                          link your account.
                      </p>

                      <Input type='email' name='lookup_email' placeholder='Patreon Email Address' />
                  </div>

                  <div className='card-action right-align'>
                      <Submit>Link Account</Submit>
                  </div>
              </Form>
          </div>`


      `<div className='account-settings'>
          { patreonStatus }
      </div>`
