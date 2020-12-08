export const OPEN_MODAL = 'OPEN_MODAL'
export function openModal(modal, args = {}) {
  const final = {
    type: OPEN_MODAL,
    modal,
    open: true,
    args,
  }

  return final
}

export function closeModal(modal, args = {}) {
  return {
    type: OPEN_MODAL,
    modal,
    open: false,
    args,
  }
}

export const openSupportModal = () => openModal('support')
export const closeSupportModal = () => closeModal('support')
export const openNewCharacterModal = () => openModal('newCharacter')
export const closeNewCharacterModal = () => closeModal('newCharacter')
export const openReportModal = ({ id, type, __typename }) =>
  openModal('report', { id, type: type || __typename })
export const closeReportModal = () => closeModal('report')
