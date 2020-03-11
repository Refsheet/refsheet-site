import * as M from 'materialize-css'

/**
 * Display Flash messages as Materialize Toast messages.
 *
 * @example
 *   Flash.info("I saved a thing!")
 *   Flash.error("I won't go away for a while.", { displayLength: 9999 })
 *   Flash.now("warn", "I guess you can specify a level...")
 */
class Flash {
  /**
   * @private
   * @param level {string} - Flash / error / logging level
   * @returns {string} - Class names appropriate for the level
   */
  static getClasses(level) {
    switch (level) {
      case 'error':
        return 'red'
      case 'warn':
        return 'yellow darken-1'
      case 'notice':
      case 'info':
        return 'green'
      case 'debug':
      default:
        return 'grey darken-1'
    }
  }

  /**
   * Flash a message at the given level. Options are passed to <tt>M.toast</tt>.
   * @param level {string} - Flash / error / logging level
   * @param message {string} - Message to display
   * @param options {Object} - Options, passed to <tt>M.toast</tt>
   */
  static now(level, message, options = {}) {
    M.toast({
      html: message,
      displayLength: 3000,
      classes: this.getClasses(level),
      ...options,
    })
  }

  /**
   * Flash an error message
   * @param message {string} - Message to display
   * @param options {Object} - Options, passed to <tt>M.toast</tt>
   */
  static error(message, options = {}) {
    this.now('error', message, options)
  }

  /**
   * Flash an warn message
   * @param message {string} - Message to display
   * @param options {Object} - Options, passed to <tt>M.toast</tt>
   */
  static warn(message, options = {}) {
    this.now('warn', message, options)
  }

  /**
   * Flash an info message
   * @param message {string} - Message to display
   * @param options {Object} - Options, passed to <tt>M.toast</tt>
   */
  static info(message, options = {}) {
    this.now('info', message, options)
  }

  /**
   * Flash an debug message
   * @param message {string} - Message to display
   * @param options {Object} - Options, passed to <tt>M.toast</tt>
   */
  static debug(message, options = {}) {
    this.now('debug', message, options)
  }
}

export default Flash
