export const OPEN_SUPPORT_MODAL = 'OPEN_SUPPORT_MODAL'
export function openSupportModal() {
  return {
    type: OPEN_SUPPORT_MODAL,
    isOpen: true,
  }
}

export function closeSupportModal() {
  return {
    type: OPEN_SUPPORT_MODAL,
    isOpen: false,
  }
}
