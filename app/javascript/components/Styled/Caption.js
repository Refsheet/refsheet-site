import React from 'react'
import styled from 'styled-components'

export const Caption = styled(props => (
  <p {...props} className={`caption ${props.className}`} />
))`
  &.caption {
    color: ${props => props.theme.accent1} !important;
  }
`
