namespace 'Views.Account.Settings'

class @Views.Account.Settings.Notifications extends React.Component
  @contextTypes:
    currentUser: React.PropTypes.object.isRequired

  constructor: (props) ->
    bp = typeof Notification isnt 'undefined' and Notification.permission is 'granted'

    @state =
      browserGranted: bp

    super props

  _enableBrowserNotifications: (e) =>
    e.preventDefault()
    if typeof Notification is 'undefined'
      console.log '[Notifications] Not supported :('
      Materialize.toast "Your browser does not support Push notifications.", 3000, 'red'

    else if Notification.permission is 'granted'
      console.log '[Notifications] Already granted.'

      @_updatePushSubscription ->
        Materialize.toast "Notification subscription updated.", 3000, 'green'

    else
      Notification.requestPermission (permission) ->
        return unless permission is 'granted'
        console.log '[Notifications] Permission granted!'

        @_updatePushSubscription ->
          Materialize.toast "Browser push notifications enabled!", 3000, 'green'

  _jiggleLever: (e) =>
    e.preventDefault()
    @_updatePushSubscription ->
      Materialize.toast "Browser push notifications (re)enabled?", 3000, 'green'

  _updatePushSubscription: (callback) ->
    navigator.serviceWorker.ready.then (registration) =>
      registration.pushManager.getSubscription().then (subscription) =>
        console.debug 'Got subscription:', subscription
        Model.put '/account/notifications/browser_push', subscription: subscription.toJSON(), (data) =>
          @setState browserGranted: true, callback


  render: ->
    return unless @context.currentUser.is_patron

    browserSupported = typeof Notification isnt 'undefined'
    browserEnabled = @state.browserGranted
    canRegister = browserSupported and not browserEnabled
    userRegistered = !!@context.currentUser.settings?.vapid
    userAuth = @context.currentUser.settings?.vapid?.auth

    vapidSettings =
      `<div className='card sp margin-bottom--none'>
          <div className='card-header'>
              <h2>Browser Push Notifications</h2>
          </div>

          <div className='card-content'>
              <p>
                  Browser push notifications are VERY experimental! If you've enabled them and
                  they don't seem to be working, you can try poking "fix it". You should see
                  a notification after you enable or fix. If you don't, <a href='mailto:mau@refsheet.net'>yell at Mau</a>.
              </p>

              <AttributeTable>
                  <Attribute name='Supported' value={ browserSupported ? 'Yes' : 'No' } />
                  <Attribute name='Granted' value={ browserEnabled ? 'Yes' : 'No' } />
                  <Attribute name='Registered' value={ userRegistered ? 'Yes' : 'No' } />
                  <Attribute name='Auth' value={ userAuth } />
              </AttributeTable>
          </div>

          <div className='card-action right-align'>
              { canRegister &&
                  <a href='#' className='btn' onClick={ this._enableBrowserNotifications }>Enable</a> }

              { !canRegister &&
                  <a href='#' className='btn' onClick={ this._jiggleLever }>Fix It?</a> }
          </div>
      </div>`

    `<div>
        { vapidSettings }
    </div>`
