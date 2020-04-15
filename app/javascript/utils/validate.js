/**
 * A validator to check for empty strings
 */
const isRequired = {
  required: true,
  match: /\S+/,
  message: "can't be blank",
  messageKey: 'validation.is_required',
}

/**
 * A validator to check if the value is numeric
 */
const isNumber = {
  match: /^\d+$/,
  message: 'must be a number',
  messageKey: 'validation.is_number',
}

/**
 * A validator to check if the value is an email
 */
const isEmail = {
  match: /@/,
  message: 'must be an email',
  messageKey: 'validation.is_email',
}

/**
 * A validator to check if a string won't become an empty slug
 */
const isSluggable = {
  match: /[a-z0-9]+/i,
  message: 'must have at least one letter or number',
  messageKey: 'validation.is_sluggable',
}

/**
 * A validator to validate a proper URL slug
 */
const isSlug = {
  match: /^[a-z0-9_-]+$/i,
  message: 'must only contain letters, numbers, and -',
  messageKey: 'validation.is_slug',
}

/**
 * A validator to ensure a proper color string
 */
const isColor = {
  match: /^#([\da-f]{3}){1,2}$|^#([\da-f]{4}){1,2}$|(rgb|hsl)a?\((\s*-?\d+%?\s*,){2}(\s*-?\d+%?\s*,?\s*\)?)(,\s*(0?\.\d+)?|1)?\)/i,
  message: 'must be a hex, rgb, or hsl color',
  messageKey: 'validation.is_css_color',
}

/**
 * A validator to ensure only HEX is allowed
 */
const isHexColor = {
  match: /^#?(?:[0-9A-F]{3}){1,2}$/i,
  message: 'must be hexadecimal color',
  messageKey: 'validation.is_hex_color',
  transform: value => (value[0] === '#' ? value : `#${value}`),
}

export {
  isRequired,
  isNumber,
  isEmail,
  isSluggable,
  isSlug,
  isHexColor,
  isColor,
}

/**
 * Validates a model and generates validation errors. Validators should be an object
 * containing at least `match` and `message` keys, and optionally `messageKey`, which
 * is an i18n key for the error message. A `required` key can be set to force validation
 * on empty values. By default, empty strings are valid.
 *
 * All values are cast to a string before validation. This is the way.
 *
 * @todo I18n is not yet integrated.
 *
 * @example
 *   const user = { email: 'no' }
 *   const errors = validate(user, {
 *     email: [
 *       {
 *         match: /@/,
 *         message: 'must have @ sign',
 *       }
 *     ]
 *   }
 *
 * @param model {Object} - Model to validate
 * @param validators {Object} - Validators for each model entry
 * @returns {Object} - Validation errors, if any
 */
function validate(model, validators = {}) {
  let errors = {}

  Object.keys(validators).map(k => {
    const value = (model[k] || '').toString()

    validators[k].map(validator => {
      // console.debug("Validating '" + value + "' against validator:", validator)

      if (!value && !validator.required) {
        // console.debug('- Valid, blank allowed.')
        return true
      }

      // Push errors here to prevent green boxes on blank validations.
      if (!errors[k]) errors[k] = []

      if (value.match(validator.match)) {
        // console.debug('- Valid, match OK.')
        return true
      }

      // console.debug("Validation error: '" + value + "' " + validator.message)

      errors[k].push(validator.message)
      return false
    })
  })

  return errors
}

/**
 * Turns an array or string of errors into a string.
 *
 * @example
 *   <TextInput name={'foo'} error={errorString(errors.foo)} />
 *
 * @param errors {string|Array} - Validation errors
 * @returns {string} - Flattened error string
 */
function errorString(errors) {
  if (!errors) {
    return ''
  }

  if (errors.join) {
    return errors.join(', ')
  }

  return errors.toString()
}

/**
 * Checks if an error result is actually an error.
 *
 * @param errors {string|Array} - Validation errors
 * @returns {boolean} - True if errors are present
 */
function isValid(errors) {
  return !errors || errors.length === 0
}

/**
 * Returns a class appropriate for presence of errors.
 *
 * @example
 *   <TextInput name={'foo'} className={errorClass(errors.foo)} />
 *
 * @param errors {string|Array} - Validation errors
 * @returns {string}
 */
function errorClass(errors) {
  if (typeof errors === 'undefined') {
    return ''
  } else if (isValid(errors)) {
    return 'valid'
  } else {
    return 'invalid'
  }
}

/**
 * The ultimate lazy helper, combines errorString and errorClass for error
 * handling on forms.
 *
 * @example
 *   <TextInput name={'foo'} {...errorProps(errors.foo)} />
 *
 * @param errors {string|Array} - Validation errors
 * @returns {{className: string, error: string}}
 */
function errorProps(errors) {
  return {
    error: errorString(errors),
    className: errorClass(errors),
  }
}

export { errorString, isValid, errorClass, errorProps }

export default validate
