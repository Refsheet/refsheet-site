import React from 'react'
import styled from 'styled-components'
import { Button as MaterialButton } from 'react-materialize'

const Button = styled(MaterialButton)`
  background-color: ${props => props.theme.primary} !important;

  &:hover {
    background-color: ${props => props.theme.accent1} !important;
  }
`

export default Button
