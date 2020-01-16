namespace 'Views.Account.Settings'

class @Views.Account.Settings.Notifications extends React.Component
  @contextTypes:
    currentUser: React.PropTypes.object.isRequired
    setCurrentUser: React.PropTypes.func.isRequired

  constructor: (props) ->
    bp = typeof Notification isnt 'undefined' and Notification.permission is 'granted'

    @state =
      browserGranted: bp

    super props

  _enableBrowserNotifications: (e) =>
    e.preventDefault()

    if typeof Notification is 'undefined' or typeof window.requestNotifications is 'undefined'
      console.log '[Notifications] Not supported :('
      Materialize.toast({ html: "Your browser does not support Push notifications.", displayLength: 3000, classes: 'red' })

    else if Notification.permission is 'granted'
      console.log '[Notifications] Already granted.'

      @_updatePushSubscription ->
        Materialize.toast({ html: "Notification subscription updated.", displayLength: 3000, classes: 'green' })

    else
      console.log('Requesting permissions.')
      __this = @
      requestNotifications ->
        Notification.requestPermission (permission) ->
          return unless permission is 'granted'
          console.log '[Notifications] Permission granted!'

          __this._updatePushSubscription ->
            Materialize.toast({ html: "Browser push notifications enabled!", displayLength: 3000, classes: 'green' })

  _jiggleLever: (e) =>
    e.preventDefault()
    @_updatePushSubscription ->
      Materialize.toast({ html: "Browser push notifications (re)enabled?", displayLength: 3000, classes: 'green' })

  _updatePushSubscription: (callback) ->
    if typeof window.requestNotifications is 'undefined'
      Materialize.toast({ html: "Your browser does not support Push notifications.", displayLength: 3000, classes: 'red' })
      return false

    requestNotifications =>
      navigator.serviceWorker.ready.then (registration) =>
        registration.pushManager.getSubscription().then (subscription) =>
          console.debug 'Got subscription:', subscription

          browser = Bowser.getParser(window.navigator.userAgent).parsedResult
          browserName = "#{browser.browser.name} #{browser.browser.version} on #{browser.os.name} #{browser.os.version} (#{browser.platform.type})"
          console.debug browserName

          Model.put '/account/notifications/browser_push', subscription: subscription.toJSON(), nickname: browserName, (data) =>
            @context.setCurrentUser data
            @setState browserGranted: true, callback


  renderSubscriptions: ->
    @context.currentUser.settings?.notifications?.vapid?.map (browser) =>
      return null if !browser
      value = browser.nickname || browser.auth
      `<Attribute key={ browser.auth } name='Browser' value={ value } />`

  render: ->
    browserSupported = (typeof Notification isnt 'undefined') and (navigator.serviceWorker)
    browserEnabled = @state.browserGranted
    canRegister = browserSupported and not browserEnabled
    userRegistered = @context.currentUser.settings?.notifications?.vapid?.length

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
                  { this.renderSubscriptions() }
              </AttributeTable>
          </div>

          { browserSupported &&
            <div className='card-action right-align'>
                { canRegister &&
                    <a href='#' className='btn' onClick={ this._enableBrowserNotifications }>Enable</a> }

                { !canRegister &&
                    <a href='#' className='btn' onClick={ this._jiggleLever }>Fix It?</a> }
            </div> }
      </div>`

    `<div>
        { vapidSettings }
    </div>`
