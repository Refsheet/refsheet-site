import React from 'react'
import styled from 'styled-components'

export const Muted = styled.div`
  color: ${props => props.theme.textLight};
  font-size: 0.9rem;
`
export const MutedHeader = styled(Muted)`
  border-bottom: 1px solid ${props => props.theme.border};
  padding-bottom: 0.25rem;
  margin-bottom: 1rem;
`

export default Muted
