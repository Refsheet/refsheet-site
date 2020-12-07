import Favico from 'favico.js-slevomat'
import { Howl, Howler } from 'howler'
import { captureException } from '@sentry/minimal'

const CYCLE_ENABLED = true

class WindowAlert {
  static dirty(key, message) {
    if (!window.RS_DIRTY) window.RS_DIRTY = {}

    window.RS_DIRTY[key] = message

    if (!window.onbeforeunload) {
      window.onbeforeunload = this.onbeforeunload
    }
  }

  static clean(key) {
    if (!window.RS_DIRTY) return

    delete window.RS_DIRTY[key]

    if (window.onbeforeunload && !this.onbeforeunload()) {
      window.onbeforeunload = null
    }
  }

  static onbeforeunload() {
    if (!window.RS_DIRTY) return false

    return Object.keys(window.RS_DIRTY).length > 0
  }

  static getCounts() {
    if (!window.RS_ALERTS) return
    const keys = Object.keys(window.RS_ALERTS)
    let count = 0
    keys.map(k => (count += window.RS_ALERTS[k].count || 0))
    return count
  }

  static updateFavicon() {
    if (!window.RS_ALERTS) return

    if (!window.RS_FAVICO) {
      window.RS_FAVICO = new Favico({
        animation: 'up',
      })
    }

    const count = WindowAlert.getCounts()

    if (count > 0) {
      window.RS_FAVICO.badge(count)
    } else {
      window.RS_FAVICO.badge(count)
      window.RS_FAVICO.reset()
    }
  }

  static add(key, message, count = 0) {
    if (!window.RS_ALERTS) window.RS_ALERTS = {}

    window.RS_ALERTS[key] = { message, count }
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
    if (!window.RS_ALERTS) return
    delete window.RS_ALERTS[key]
    window.RS_ALERT_CURRENT = 0
    WindowAlert.updateFavicon()
  }

  static next() {
    if (!window.RS_ALERTS) return
    const keys = Object.keys(window.RS_ALERTS)
    const i = window.RS_ALERT_CURRENT || 0

    let next = i + 1
    if (next > keys.length - 1) next = 0

    if (CYCLE_ENABLED) window.RS_ALERT_CURRENT = next

    return window.RS_ALERTS[keys[i]] || {}
  }

  static showNext() {
    const title = WindowAlert.next().message
    const titles = []
    titles.push(title)
    titles.push('Refsheet.net')

    const count = WindowAlert.getCounts()
    let countShow = ''

    if (count > 0 && !CYCLE_ENABLED) {
      countShow = `(${count}) `
    }

    document.title = countShow + [].concat.apply([], titles).join(' - ')
  }

  static beginCycle() {
    if (window.RS_ALERT_INTERVAL || !CYCLE_ENABLED) return
    window.RS_ALERT_INTERVAL = setInterval(WindowAlert.showNext, 3000)
  }

  static initSound(options) {
    const notificationDing = new Howl({
      src: [...options.notificationSoundPaths],
    })

    window.RS_SOUND = {
      notificationDing,
    }
  }

  static playSound(key) {
    if (window.RS_SOUND && window.RS_SOUND[key]) {
      try {
        window.RS_SOUND[key].play()
      } catch (e) {
        captureException(e)
        console.error(e)
      }
    }
  }
}

export default WindowAlert
