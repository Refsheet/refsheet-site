import styled from 'styled-components'
import { default as V1Modal } from 'v1/shared/Modal'

const Modal = styled(V1Modal)`
  background-color: ${props => props.theme.cardBackground} !important;
  color: ${props => props.theme.textColor} !important;

  .modal-header,
  .modal-actions,
  .modal-footer {
    background-color: ${props => props.theme.cardHeaderBackground} !important;

    h1,
    h2 {
      color: ${props => props.theme.accent1} !important;
    }
  }
`

export default Modal
