export const OPEN_MODAL = 'OPEN_MODAL'
export function openModal(modal) {
  return {
    type: OPEN_MODAL,
    modal,
    open: true,
  }
}

export function closeModal(modal) {
  return {
    type: OPEN_MODAL,
    modal,
    open: false,
  }
}

export const openSupportModal = () => openModal('support')
export const closeSupportModal = () => closeModal('support')
export const openNewCharacterModal = () => openModal('newCharacter')
export const closeNewCharacterModal = () => closeModal('newCharacter')
