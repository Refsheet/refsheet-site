import Favico from 'favico.js-slevomat'

const CYCLE_ENABLED = false

class WindowAlert {
  static getCounts() {
    if(!window.RS_ALERTS) return
    const keys = Object.keys(window.RS_ALERTS)
    let count = 0
    keys.map((k) => count += window.RS_ALERTS[k].count || 0)
    return count
  }

  static updateFavicon() {
    if(!window.RS_ALERTS) return

    const favico = new Favico({
      animation: 'up'
    })

    const count = WindowAlert.getCounts()

    if(count > 0) {
      favico.badge(count)
    } else {
      favico.reset()
    }
  }

  static add(key, message, count=0) {
    if(!window.RS_ALERTS)
      window.RS_ALERTS = {}

    window.RS_ALERTS[key] = {message, count}
    WindowAlert.beginCycle()
    WindowAlert.updateFavicon()
  }

  static addNow(key, message) {
    WindowAlert.add(key, message)
    const keys = Object.keys(window.RS_ALERTS)
    window.RS_ALERT_CURRENT = keys.indexOf(key)
    WindowAlert.showNext()
  }

  static clear(key) {
    if(!window.RS_ALERTS) return
    delete window.RS_ALERTS[key]
    window.RS_ALERT_CURRENT = 0
    WindowAlert.updateFavicon()
  }

  static next() {
    if(!window.RS_ALERTS) return
    const keys = Object.keys(window.RS_ALERTS)
    const i = window.RS_ALERT_CURRENT || 0

    let next = i + 1
    if(next > keys.length - 1) next = 0

    if(CYCLE_ENABLED)
      window.RS_ALERT_CURRENT = next

    return window.RS_ALERTS[keys[i]] || {}
  }

  static showNext() {
    const title = WindowAlert.next().message
    const titles = []
    titles.push(title)
    titles.push('Refsheet.net')

    const count = WindowAlert.getCounts()
    let countShow = ''

    if(count > 0 && !CYCLE_ENABLED) {
      countShow = `(${count}) `
    }

    document.title = countShow + [].concat.apply([], titles).join(' - ')
  }

  static beginCycle() {
    if(window.RS_ALERT_INTERVAL || !CYCLE_ENABLED) return
    window.RS_ALERT_INTERVAL = setInterval(WindowAlert.showNext, 3000)
  }
}

export default WindowAlert
