import React from 'react'
import styled, { withTheme } from 'styled-components'
import { Style } from 'react-style-tag'
import Main from 'Shared/Main'

const GlobalStyle = ({ theme }) => (
  <Style>{`
    body {
      color: ${theme.text} !important;
      background-color: ${theme.background} !important;
    }

    a, a:link, a:visited, .tabs .tab a {
      color: ${theme.accent1};
    }

    a:hover, a:active, .tabs .tab a:hover {
      color: ${theme.accent2};
    }

    .card {
      background-color: ${theme.cardBackground} !important;
    }

    .card .card-header {
      background-color: ${theme.cardHeaderBackground};
    }
  `}</Style>
)

export const ThemedMain = styled(Main)`
  color: ${props => props.theme.text} !important;
  background-color: ${props => props.theme.background} !important;

  a,
  a:link,
  a:visited,
  .tabs .tab a {
    color: ${props => props.theme.accent1};
  }

  a:hover,
  a:active,
  .tabs .tab a:hover {
    color: ${props => props.theme.accent2};
  }

  .card {
    background-color: ${props => props.theme.cardBackground} !important;
  }

  .card .card-header {
    background-color: ${props => props.theme.cardHeaderBackground};
  }

  .attribute-data .key {
    color: ${props => props.theme.accent2} !important;
  }

  ul li:before {
    background-color: ${props => props.theme.accent1} !important;
  }
`

export default withTheme(GlobalStyle)
