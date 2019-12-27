import React from 'react'
import styled from 'styled-components'

const _SidebarLink = ({ to, icon, children, className, onClick }) => (
  <a href={to} className={className} onClick={onClick}>
    <i className={'material-icons left'}>{icon}</i>
    {children}
  </a>
)

const SidebarLink = styled(_SidebarLink)`
  height: 2.5rem;
  line-height: 2.5rem;
  vertical-align: middle;
  padding: 0;
  display: block;
  color: ${props => props.theme.textMedium} !important;

  i.material-icons {
    height: 2.5rem;
    line-height: 2.5rem;
    color: ${props => props.theme.textLight} !important;
  }

  &:hover {
    color: ${props => props.theme.text} !important;
  }

  &.active {
    color: ${props => props.theme.accent1} !important;
  }
`

export { SidebarLink }
