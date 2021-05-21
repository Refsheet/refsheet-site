import React from 'react'
import CharacterPolicy from './CharacterPolicy'
import { withCurrentUser } from '../utils/compose'

const policies = {
  Character: CharacterPolicy,
}

/**
 * Authorize an action against an object. This requires a `__typename` attribute to be set on the
 * `object` to resolve a policy. Alternatively, you may specify a policy in the options object.
 *
 * @example
 *   if (authorize(this.props.character, 'update')) {
 *     callSomeMutation()
 *   }
 *
 * @todo
 *  - Get user from Redux
 *  - Add validators for required keys on object, user
 *
 *
 * @param object {Object} - Target object to authorize for
 * @param action {string} - The action in the policy to authorize against (default: 'update')
 * @param user {Object}   - The user to authorize with
 * @param policy {Policy} - An optional policy class to use for this action
 * @param args {Array}    - Optional args to pass to the policy check function
 * @returns {boolean}     - True if authorized, false otherwise
 */
function authorize(
  object,
  user = null,
  action = 'update',
  policy = null,
  args = []
) {
  let activePolicy

  if (!policy || typeof policy === 'string') {
    activePolicy =
      policies[policy] || policies[object.__typename] || policies[object]
  } else {
    activePolicy = policy
  }

  if (!activePolicy) {
    console.error('No policy found for ' + object, {
      user,
      action,
      object,
      policy,
    })
    return false
  }

  const policyInstance = new activePolicy(object, user)
  const check = policyInstance[action]

  if (!check) {
    console.error(
      'Policy ' + activePolicy.name + ' does not define action ' + action,
      { user, action, object, activePolicy }
    )
    return false
  }

  console.debug(
    'Checking policy ' + activePolicy.name + ', action: ' + action,
    { user, action, object, policyInstance, check }
  )

  return check.apply(policyInstance, args)
}

/**
 * React component wrapper for authorize()
 *
 * @param object
 * @param action
 * @param children
 * @param user
 * @param policy
 * @param args
 * @returns {null|*}
 * @constructor
 */
const Authorized = withCurrentUser()(
  ({ object, action, children, user, currentUser, policy, args }) => {
    if (authorize(object, user || currentUser, action, policy, args)) {
      return children
    } else {
      return null
    }
  }
)

function withAuthorize(Component) {
  return withCurrentUser()(props => {
    const authorizeWithUser = (object, action, policy, args) => {
      return authorize(object, props.currentUser, action, policy, args)
    }

    return <Component {...props} authorize={authorizeWithUser} />
  })
}

export { Authorized, withAuthorize }
export default authorize
