import Policy from './Policy'

class CharacterPolicy extends Policy {
  create() {
    return false
  }

  update() {
    return (!this.object.pending_transfer && this.object.username === this.user.username)
  }

  transfer() {
    return this.update()
  }

  destroy() {
    return this.update()
  }
}

export default CharacterPolicy