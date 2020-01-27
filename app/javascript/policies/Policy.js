/**
 * Base Policy class used for defining new policies. The new Policy class should define
 * methods that match actions. By default, this class will be initialized by {authorize}
 * and set `this.object` and `this.user`.
 *
 * @example
 *   class SomePolicy extends Policy {
 *     update() {
 *       return this.object.user_id == this.user.id
 *     }
 *   }
 */
class Policy {
  constructor(object, user) {
    this.user = user
    this.object = object
  }

  show() {
    return false
  }

  create() {
    return false
  }

  update() {
    return false
  }

  destroy() {
    return false
  }
}

export default Policy
