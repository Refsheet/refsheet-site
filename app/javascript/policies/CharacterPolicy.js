import Policy from './Policy'

class CharacterPolicy extends Policy {
  show() {
    return true
  }

  create() {
    return false
  }

  update() {
    return (
      !this.object.pending_transfer &&
      (this.object.username === this.user.username || this.object.can_edit)
    )
  }

  transfer() {
    return this.update()
  }

  destroy() {
    return this.update()
  }
}

export default CharacterPolicy
