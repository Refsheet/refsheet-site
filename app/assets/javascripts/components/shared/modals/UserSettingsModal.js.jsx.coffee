@UserSettingsModal = React.createClass
  getInitialState: ->
    user: @props.user

  handleSettingsClose: (e) ->
    M.Modal.getInstance(document.getElementById('user-settings-modal')).close()

  handleSettingsChange: (setting, onSuccess, onError) ->
    o = {}
    o[setting.id] = setting.value

    $.ajax
      url: @state.user.path
      type: 'PATCH'
      data: user: o
      success: (data) =>
        @setState user: data
        onSuccess(value: data[setting.id]) if onSuccess?
      error: (error) =>
        onError(value: error.responseJSON?.errors[setting.id]) if onError?

  render: ->
    `<Modal id='user-settings-modal'>
        <div className='card-panel margin-bottom--large green darken-1 white-text'>
            <div className='strong'>Notice!</div>
            This window will be going away soon! Please use the Settings link in the left
            menu of your user dashboard to change your account settings.
        </div>

        <h2>User Settings</h2>
        <p>Be sure to save each row individually.</p>

        <AttributeTable onAttributeUpdate={ this.handleSettingsChange }
                        freezeName hideNotesForm>
            <Attribute id='name' name='Display Name' value={ this.state.user.name } />
            <Attribute id='email' name='Email Address' value={ this.state.user.email } />
        </AttributeTable>

        <h3>Danja Zone!</h3>
        <p>Changing these values can break links you've posted elsewhere!</p>
        <AttributeTable onAttributeUpdate={ this.handleSettingsChange }
                        freezeName hideNotesForm>
            <Attribute id='username' name='Username' value={ this.state.user.username } />
        </AttributeTable>

        <div className='actions margin-top--large'>
            <a className='btn' onClick={ this.handleSettingsClose }>Close</a>
        </div>
    </Modal>`