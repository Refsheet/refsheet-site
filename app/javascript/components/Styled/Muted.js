import React from 'react'
import styled from 'styled-components'
import { Link } from 'react-router-dom'

export const Muted = styled.div`
  color: ${props => props.theme.textLight};
  font-size: 0.9rem;

  a {
    color: ${props => props.theme.textLight};

    &:hover {
      color: ${props => props.theme.textLight};
      text-decoration: underline;
    }
  }
`

export const MutedHeader = styled(Muted)`
  border-bottom: 1px solid ${props => props.theme.border};
  padding-bottom: 0.25rem;
  margin-bottom: 1rem;
`

export const MutedLink = styled(Link)`
  color: ${props => props.theme.textLight} !important;
  font-size: 0.9rem;

  &:hover {
    color: ${props => props.theme.textLight};
    text-decoration: underline;
  }
`

export const MutedAnchor = styled.a`
  color: ${props => props.theme.textLight} !important;
  font-size: 0.9rem;

  &:hover {
    color: ${props => props.theme.textLight};
    text-decoration: underline;
  }
`

export const TextLight = styled.span`
  color: ${props => props.theme.textLight};
`

export default Muted
