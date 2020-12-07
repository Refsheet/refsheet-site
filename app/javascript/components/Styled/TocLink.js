import React from 'react'
import styled from 'styled-components'
import smoothScroll from 'smoothscroll'

const goTo = target => e => {
  e.preventDefault()
  const el = document.querySelector(target)
  smoothScroll(el.offsetTop)
}

const TocLink = ({ to, children, className }) => (
  <a href={to} onClick={goTo(to)} className={className}>
    {children}
  </a>
)

export default styled(TocLink)`
  color: ${props => props.theme.textMedium} !important;
  margin-bottom: 0.5rem;
  display: block;

  &:hover {
    color: ${props => props.theme.text} !important;
    border-left-color: ${props => props.theme.accent2} !important;
  }

  &.active {
    color: ${props => props.theme.accent1} !important;
    border-left-color: ${props => props.theme.accent2} !important;
  }
`
