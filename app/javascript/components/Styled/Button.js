import React from 'react'
import styled from 'styled-components'
import { Button as MaterialButton } from 'react-materialize'
import { buildShadow } from './common'

const Button = styled(MaterialButton)`
  background-color: ${props => props.theme.primary} !important;
  box-shadow: ${props => buildShadow(props.theme.cardShadow, 1)};

  &.btn-secondary {
    background-color: ${props => props.theme.accent2} !important;

    &:hover {
      background-color: ${props => props.theme.accent2} !important;
    }
  }

  &:hover {
    background-color: ${props => props.theme.accent1} !important;
  }
  
  &.btn-flat {
    background-color: transparent !important;
    color: ${props => props.theme.primary} !important;
    border: 1px solid ${props => props.theme.borderColor} !important;
    transition: all 0.3s ease;
    box-shadow: none;
    
    &.btn-secondary {
      color: ${props => props.theme.accent2} !important;
      border-color: ${props => props.theme.accent2} !important;
    }
    
    &.btn-muted {
      color: rgba(255, 255, 255, 0.6) !important;
      border-color: rgba(255, 255, 255, 0.6) !important;
    }
    
    &:hover {
      border-color: ${props => props.theme.accent1} !important;
      color: ${props => props.theme.accent1} !important;
      
      &.btn-secondary {
        background-color: transparent !important;
        color: ${props => props.theme.accent2} !important;
        border-color: ${props => props.theme.accent2} !important;
      }
      
      &.btn-muted {
        color: rgba(255, 255, 255, 0.8) !important;
        border-color: rgba(255, 255, 255, 0.8) !important;
    }
  }
`

export default Button
