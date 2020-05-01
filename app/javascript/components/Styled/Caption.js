import React from 'react'
import styled from 'styled-components'

// export const Caption = styled(props => (
//   <p {...props} className={`caption ${props.className}`} />
// ))`
//   &.caption {
//     color: ${props => props.theme.accent1} !important;
//   }
// `

export const Caption = styled.div`
  font-size: 1.2rem;
  font-weight: 300;
  color: ${props => props.theme.accent1};
`

export const MutedCaption = styled.div`
  font-size: 1.2rem;
  font-weight: 300;
  color: ${props => props.theme.textLight};
`
