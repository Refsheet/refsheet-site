/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
namespace('Views.Account.Settings');

const Cls = (this.Views.Account.Settings.Notifications = class Notifications extends React.Component {
  static initClass() {
    this.contextTypes = {
      currentUser: React.PropTypes.object.isRequired,
      setCurrentUser: React.PropTypes.func.isRequired
    };
  }

  constructor(props) {
    {
      // Hack: trick Babel/TypeScript into allowing this before super.
      if (false) { super(); }
      let thisFn = (() => { return this; }).toString();
      let thisName = thisFn.match(/return (?:_assertThisInitialized\()*(\w+)\)*;/)[1];
      eval(`${thisName} = this;`);
    }
    this._enableBrowserNotifications = this._enableBrowserNotifications.bind(this);
    this._jiggleLever = this._jiggleLever.bind(this);
    const bp = (typeof Notification !== 'undefined') && (Notification.permission === 'granted');

    this.state =
      {browserGranted: bp};

    super(props);
  }

  _enableBrowserNotifications(e) {
    e.preventDefault();

    if ((typeof Notification === 'undefined') || (typeof window.requestNotifications === 'undefined')) {
      console.log('[Notifications] Not supported :(');
      return Materialize.toast({ html: "Your browser does not support Push notifications.", displayLength: 3000, classes: 'red' });

    } else if (Notification.permission === 'granted') {
      console.log('[Notifications] Already granted.');

      return this._updatePushSubscription(() => Materialize.toast({ html: "Notification subscription updated.", displayLength: 3000, classes: 'green' }));

    } else {
      console.log('Requesting permissions.');
      const __this = this;
      return requestNotifications(() => Notification.requestPermission(function(permission) {
        if (permission !== 'granted') { return; }
        console.log('[Notifications] Permission granted!');

        return __this._updatePushSubscription(() => Materialize.toast({ html: "Browser push notifications enabled!", displayLength: 3000, classes: 'green' }));
      }));
    }
  }

  _jiggleLever(e) {
    e.preventDefault();
    return this._updatePushSubscription(() => Materialize.toast({ html: "Browser push notifications (re)enabled?", displayLength: 3000, classes: 'green' }));
  }

  _updatePushSubscription(callback) {
    if (typeof window.requestNotifications === 'undefined') {
      Materialize.toast({ html: "Your browser does not support Push notifications.", displayLength: 3000, classes: 'red' });
      return false;
    }

    return requestNotifications(() => {
      return navigator.serviceWorker.ready.then(registration => {
        return registration.pushManager.getSubscription().then(subscription => {
          console.debug('Got subscription:', subscription);

          const browser = Bowser.getParser(window.navigator.userAgent).parsedResult;
          const browserName = `${browser.browser.name} ${browser.browser.version} on ${browser.os.name} ${browser.os.version} (${browser.platform.type})`;
          console.debug(browserName);

          return Model.put('/account/notifications/browser_push', {subscription: subscription.toJSON(), nickname: browserName}, data => {
            this.context.setCurrentUser(data);
            return this.setState({browserGranted: true}, callback);
          });
        });
      });
    });
  }


  renderSubscriptions() {
    return __guard__(__guard__(this.context.currentUser.settings != null ? this.context.currentUser.settings.notifications : undefined, x1 => x1.vapid), x => x.map(browser => {
      if (!browser) { return null; }
      const value = browser.nickname || browser.auth;
      return <Attribute key={ browser.auth } name='Browser' value={ value } />;
    }));
  }

  render() {
    const browserSupported = (typeof Notification !== 'undefined') && (navigator.serviceWorker);
    const browserEnabled = this.state.browserGranted;
    const canRegister = browserSupported && !browserEnabled;
    const userRegistered = __guard__(__guard__(this.context.currentUser.settings != null ? this.context.currentUser.settings.notifications : undefined, x1 => x1.vapid), x => x.length);

    const vapidSettings =
      <div className='card sp margin-bottom--none'>
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
      </div>;

    return <div>
        { vapidSettings }
    </div>;
  }
});
Cls.initClass();

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}